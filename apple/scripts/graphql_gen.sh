cd BuildTools

SDKROOT=macosx

swift run swift-graphql \
  http://localhost:4000/api/graphql \
  --config "$SRCROOT/../swiftgraphql.yml" \
  --output "$SRCROOT/../RuminerKit/Sources/Services/DataService/GQLSchema.swift"

  sed -i '' '1s/^/\/\/ swiftlint:disable all\n/' './../RuminerKit/Sources/Services/DataService/GQLSchema.swift'
