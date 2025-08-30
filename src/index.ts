import 'reflect-metadata'
require('dotenv').config()
import { ApolloServer } from 'apollo-server-express'
import express from 'express'
import http from 'http';
import {
  ApolloServerPluginDrainHttpServer,
  ApolloServerPluginLandingPageLocalDefault,
} from "apollo-server-core";
import { WebSocketServer } from 'ws';
import { useServer } from 'graphql-ws/lib/use/ws';
import { buildSchema } from 'type-graphql'
import { applyMiddleware } from 'graphql-middleware'
import permissions from './shield/Permissions.shield'
import { pubsub } from './graphql/PubSub/pubsub'
import { getPrisma } from './utils/helperFunctions';
import { resolvers } from "@generated/typegraphql-prisma";
import { UserResolver } from './graphql/resolvers/UserResolver';


const prisma = getPrisma()

const PORT = process.env.PORT ?? 4000

const main = async () => {
  const schema = await buildSchema({
    resolvers: [...resolvers, UserResolver],
    emitSchemaFile: true,
    pubSub: pubsub,
  })


  //Apply permissions using graphql-shield
  const schemaWithPermissions = applyMiddleware(schema, permissions)

  const app = express()
  const httpServer = http.createServer(app);
  const wsServer = new WebSocketServer({
    server: httpServer,
    // Pass a different path here if your ApolloServer serves at
    // a different path.
    path: '/graphql',
  });

  const serverCleanup = useServer({ schema }, wsServer);

  const apolloServer = new ApolloServer({
    schema: schemaWithPermissions,
    context: ({ req, res }) => ({ prisma, req, res }),
    csrfPrevention: true,
    cache: "bounded",
    plugins: [
      // Proper shutdown for the HTTP server.
      ApolloServerPluginDrainHttpServer({ httpServer }),

      // Proper shutdown for the WebSocket server.
      {
        async serverWillStart() {
          return {
            async drainServer() {
              await serverCleanup.dispose();
            },
          };
        },
      },
      ApolloServerPluginLandingPageLocalDefault({ embed: true }),
    ],
  })


  await apolloServer.start()
  apolloServer.applyMiddleware({ app })

  httpServer.listen(PORT, () => {
    console.log(`Server started at http://localhost:${PORT}/graphql`)
  })
}
main()
