import {
    pgTable,
    serial,
    text,
    varchar,
    timestamp,
    integer,
    date,
    uniqueIndex,
    primaryKey,
    foreignKey
  } from "drizzle-orm/pg-core";
  
  // 1. Nodes
  export const nodes = pgTable("nodes", {
    id: serial("id").primaryKey(),
    content: text("content"),
    nodeType: varchar("node_type", { length: 50 }),
    createdAt: timestamp("created_at", { withTimezone: true }).defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).defaultNow()
  });
  
  // 2. Parent–Child Relationships
  export const nodeRelations = pgTable("node_relations", {
    parentId: integer("parent_id").references(() => nodes.id, { onDelete: "cascade" }),
    childId: integer("child_id").references(() => nodes.id, { onDelete: "cascade" }),
    position: integer("position").default(0),
  }, (t) => ({
    pk: primaryKey({ columns: [t.parentId, t.childId] })
  }));
  
  // 3. Dynamic Fields
  export const fields = pgTable("fields", {
    id: serial("id").primaryKey(),
    nodeId: integer("node_id").references(() => nodes.id, { onDelete: "cascade" }),
    fieldName: varchar("field_name", { length: 100 }).notNull(),
    fieldType: varchar("field_type", { length: 50 }).notNull(),
    fieldValue: text("field_value"),
  }, (t) => ({
    uniqueField: uniqueIndex("unique_field").on(t.nodeId, t.fieldName)
  }));
  
  // 4a. Supertags
  export const supertags = pgTable("supertags", {
    id: serial("id").primaryKey(),
    name: varchar("name", { length: 100 }).notNull().unique(),
    description: text("description")
  });
  
  // 4b. Supertag Field Definitions
  export const supertagFields = pgTable("supertag_fields", {
    id: serial("id").primaryKey(),
    supertagId: integer("supertag_id").references(() => supertags.id, { onDelete: "cascade" }),
    fieldName: varchar("field_name", { length: 100 }).notNull(),
    fieldType: varchar("field_type", { length: 50 }).notNull(),
    fieldOrder: integer("field_order").default(0)
  }, (t) => ({
    uniqueSupertagField: uniqueIndex("unique_supertag_field").on(t.supertagId, t.fieldName)
  }));
  
  // 4c. Node to Supertag mapping
  export const nodeSupertags = pgTable("node_supertags", {
    nodeId: integer("node_id").references(() => nodes.id, { onDelete: "cascade" }),
    supertagId: integer("supertag_id").references(() => supertags.id, { onDelete: "cascade" })
  }, (t) => ({
    pk: primaryKey({ columns: [t.nodeId, t.supertagId] })
  }));
  
  // 5. Node-to-Node References
  export const nodeReferences = pgTable("node_references", {
    sourceNodeId: integer("source_node_id").references(() => nodes.id, { onDelete: "cascade" }),
    targetNodeId: integer("target_node_id").references(() => nodes.id, { onDelete: "cascade" }),
    context: text("context")
  }, (t) => ({
    pk: primaryKey({ columns: [t.sourceNodeId, t.targetNodeId] })
  }));
  
  // 6. Daily Notes
  export const dailyNotes = pgTable("daily_notes", {
    nodeId: integer("node_id").primaryKey().references(() => nodes.id, { onDelete: "cascade" }),
    noteDate: date("note_date").notNull()
  }, (t) => ({
    uniqueDate: uniqueIndex("unique_note_date").on(t.noteDate)
  }));
  
  // 7. Saved Queries
  export const savedQueries = pgTable("saved_queries", {
    id: serial("id").primaryKey(),
    name: varchar("name", { length: 100 }).notNull(),
    queryText: text("query_text"),
    createdAt: timestamp("created_at", { withTimezone: true }).defaultNow()
  });
  