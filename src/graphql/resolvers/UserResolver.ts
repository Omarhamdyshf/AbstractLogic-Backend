import { Arg, Ctx, Query, Resolver } from "type-graphql";
import { User, UserWhereUniqueInput } from "@generated/typegraphql-prisma";
import { Context } from "../../Context";
import { Prisma } from "@prisma/client";

@Resolver(User)
export class UserResolver {
  @Query(() => User)
  async getUserCustom(@Arg("where") where: UserWhereUniqueInput,  @Ctx() { prisma }: Context) {
    return await prisma.user.findUnique({ where: where as Prisma.UserWhereUniqueInput});
  }
}