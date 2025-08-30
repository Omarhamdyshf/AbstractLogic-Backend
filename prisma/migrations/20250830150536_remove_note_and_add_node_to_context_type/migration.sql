/*
  Warnings:

  - The values [NOTE] on the enum `ContextType` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ContextType_new" AS ENUM ('CONNECTION', 'MAPPING', 'CONDITIONAL', 'NODE');
ALTER TABLE "contexts" ALTER COLUMN "context_type" TYPE "ContextType_new" USING ("context_type"::text::"ContextType_new");
ALTER TYPE "ContextType" RENAME TO "ContextType_old";
ALTER TYPE "ContextType_new" RENAME TO "ContextType";
DROP TYPE "ContextType_old";
COMMIT;

-- AlterTable
ALTER TABLE "contexts" ALTER COLUMN "context_type" SET DEFAULT 'NODE';
