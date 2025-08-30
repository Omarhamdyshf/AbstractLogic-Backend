/*
  Warnings:

  - The values [CONNECTION] on the enum `ContextType` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `connection_type` on the `contexts` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "RelationshipType" AS ENUM ('HAS_A', 'CONTAINS', 'PARENT_OF', 'DEPENDS_ON', 'RELATES_TO', 'REFERENCES');

-- AlterEnum
BEGIN;
CREATE TYPE "ContextType_new" AS ENUM ('RELATIONSHIP', 'MAPPING', 'CONDITIONAL', 'NODE');
ALTER TABLE "contexts" ALTER COLUMN "context_type" DROP DEFAULT;
ALTER TABLE "contexts" ALTER COLUMN "context_type" TYPE "ContextType_new" USING ("context_type"::text::"ContextType_new");
ALTER TYPE "ContextType" RENAME TO "ContextType_old";
ALTER TYPE "ContextType_new" RENAME TO "ContextType";
DROP TYPE "ContextType_old";
ALTER TABLE "contexts" ALTER COLUMN "context_type" SET DEFAULT 'NODE';
COMMIT;

-- AlterTable
ALTER TABLE "contexts" DROP COLUMN "connection_type",
ADD COLUMN     "relationship_type" "RelationshipType";

-- DropEnum
DROP TYPE "ConnectionType";
