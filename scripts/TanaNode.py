from datetime import datetime
import enum

from sqlalchemy import (
    create_engine, Column, Integer, String, Text, ForeignKey,
    DateTime, Enum, Boolean, Table
)
from sqlalchemy.orm import relationship, backref, sessionmaker, declarative_base

Base = declarative_base()

# ------------------------------------------------------------------------------
# ENUMERATIONS
# ------------------------------------------------------------------------------

class NodeType(enum.Enum):
    NOTE = 'note'
    TASK = 'task'
    DATE = 'date'
    REFERENCE = 'reference'
    # Extend for additional types as needed

class FieldType(enum.Enum):
    TEXT = 'text'
    CHECKBOX = 'checkbox'
    DATE = 'date'
    URL = 'url'
    NODE_REFERENCE = 'node_reference'
    OPTIONS = 'options'
    # Add more types if necessary

# ------------------------------------------------------------------------------
# ASSOCIATIVE TABLES (MANY-TO-MANY RELATIONSHIPS)
# ------------------------------------------------------------------------------

# A self-referential association table for many-to-many references between nodes.
node_reference_association = Table(
    'node_reference', Base.metadata,
    Column('source_node_id', Integer, ForeignKey('nodes.id'), primary_key=True),
    Column('target_node_id', Integer, ForeignKey('nodes.id'), primary_key=True)
)

# ------------------------------------------------------------------------------
# MODELS
# ------------------------------------------------------------------------------

class SuperTag(Base):
    """
    SuperTag: A template definition for nodes.
    Each SuperTag can define a set of fields (attributes) that nodes using this tag should have.
    For example, a #Book SuperTag might require fields such as "Author", "Publication Date", etc.
    """
    __tablename__ = 'supertags'

    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    # A SuperTag can have multiple field definitions.
    fields = relationship('SuperTagField', backref='supertag', cascade="all, delete-orphan")

    def __repr__(self):
        return f"<SuperTag(name='{self.name}')>"


class SuperTagField(Base):
    """
    SuperTagField: Defines a field (attribute) for a SuperTag.
    A field consists of a name and a type. Optionally, you might add metadata such as
    default values, allowed options (for dropdowns), etc.
    """
    __tablename__ = 'supertag_fields'

    id = Column(Integer, primary_key=True)
    supertag_id = Column(Integer, ForeignKey('supertags.id'), nullable=False)
    field_name = Column(String(50), nullable=False)
    field_type = Column(Enum(FieldType), nullable=False)
    # Optionally, store allowed options for 'OPTIONS' type.
    options = Column(Text)

    def __repr__(self):
        return f"<SuperTagField({self.field_name}: {self.field_type.value})>"


class NodeAttribute(Base):
    """
    NodeAttribute: A dynamic key-value property for a node.
    This is used to store inline data like "Author:: John Doe" or "Due Date:: 2025-04-11"
    associated with a node.
    """
    __tablename__ = 'node_attributes'

    id = Column(Integer, primary_key=True)
    node_id = Column(Integer, ForeignKey('nodes.id'), nullable=False)
    key = Column(String(50), nullable=False)
    value = Column(Text, nullable=False)

    def __repr__(self):
        return f"<NodeAttribute({self.key}='{self.value}')>"


class Node(Base):
    """
    Node: The core unit in Tana.
    
    Each node can represent notes, tasks, or date pages. Nodes are self-referential,
    allowing for infinite nesting. Nodes might be assigned a SuperTag to follow a specific template,
    and they can have many attributes attached.
    """
    __tablename__ = 'nodes'

    id = Column(Integer, primary_key=True)
    content = Column(Text)                          # The text or body of the node.
    node_type = Column(Enum(NodeType), default=NodeType.NOTE)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Hierarchical structure: Each node can have a parent (allowing infinite nesting).
    parent_id = Column(Integer, ForeignKey('nodes.id'), nullable=True)
    children = relationship(
        "Node",
        backref=backref('parent', remote_side=[id]),
        cascade="all, delete-orphan"
    )

    # SuperTag relationship: Optional assignment to a SuperTag if this node follows a template.
    supertag_id = Column(Integer, ForeignKey('supertags.id'), nullable=True)
    supertag = relationship('SuperTag', backref='nodes')

    # Custom attributes (fields) that users add directly into the node.
    attributes = relationship('NodeAttribute', backref='node', cascade="all, delete-orphan")

    # Self-referential many-to-many for cross-node references.
    references = relationship(
        'Node',
        secondary=node_reference_association,
        primaryjoin=id == node_reference_association.c.source_node_id,
        secondaryjoin=id == node_reference_association.c.target_node_id,
        backref='referred_by'
    )

    # For task-specific features
    is_done = Column(Boolean, default=False)
    due_date = Column(DateTime, nullable=True)      # For task scheduling
    recurring = Column(Boolean, default=False)

    def __repr__(self):
        return f"<Node(id={self.id}, type={self.node_type.value}, content='{self.content[:20]}')>"

# ------------------------------------------------------------------------------
# EXAMPLE: SESSION CREATION AND USAGE
# ------------------------------------------------------------------------------

if __name__ == "__main__":
    # Create an in-memory SQLite database (change the connection URL as needed)
    engine = create_engine('sqlite:///:memory:', echo=True)
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()

    # Create a SuperTag for books with custom fields.
    book_tag = SuperTag(name="Book", description="Template for tracking books")
    book_tag.fields.append(SuperTagField(field_name="Author", field_type=FieldType.TEXT))
    book_tag.fields.append(SuperTagField(field_name="Published", field_type=FieldType.DATE))
    session.add(book_tag)
    session.commit()

    # Create a root node (could represent a daily note or an inbox entry)
    root_node = Node(content="Daily Notes - 2025-04-11", node_type=NodeType.DATE)
    session.add(root_node)
    session.commit()

    # Create a child node with a SuperTag (e.g., a book note)
    book_node = Node(
        content="Learning Python ORM patterns", 
        node_type=NodeType.NOTE,
        parent=root_node,
        supertag=book_tag
    )
    # Dynamically add attributes corresponding to the SuperTag fields
    book_node.attributes.append(NodeAttribute(key="Author", value="John Doe"))
    book_node.attributes.append(NodeAttribute(key="Published", value="2025-01-15"))
    session.add(book_node)
    session.commit()

    # Create a task node as a child of the daily note
    task_node = Node(
        content="Review ORM design patterns", 
        node_type=NodeType.TASK, 
        parent=root_node,
        due_date=datetime(2025, 4, 12),
        recurring=False
    )
    session.add(task_node)
    session.commit()

    # Create cross-references: e.g., the book node might reference the task node
    book_node.references.append(task_node)
    session.commit()

    # Querying examples: Retrieve a node and its children
    queried_root = session.query(Node).filter_by(id=root_node.id).one()
    print("Root Node:", queried_root)
    print("Children:")
    for child in queried_root.children:
        print("  ", child)

    # Querying attributes for a node (e.g., book_node)
    for attribute in book_node.attributes:
        print(f"{attribute.key} => {attribute.value}")
