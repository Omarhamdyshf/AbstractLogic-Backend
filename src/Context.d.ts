import { PrismaClient } from '@prisma/client'
import { Request, Response } from "express";
//TODO Add sequelize to the Context
export interface Context {
  userId: bigint,
  req: Request,
  res: Response,
  next: Function,
  prisma: PrismaClient,
}
