-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'USER', 'VIEWER');

-- CreateEnum
CREATE TYPE "ContextType" AS ENUM ('NOTE', 'CONNECTION', 'MAPPING', 'CONDITIONAL');

-- CreateEnum
CREATE TYPE "ConnectionType" AS ENUM ('HAS_A', 'CONTAINS', 'PARENT_OF', 'DEPENDS_ON', 'RELATES_TO', 'REFERENCES');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'USER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contexts" (
    "id" TEXT NOT NULL,
    "context_type" "ContextType" NOT NULL,
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "markdown_content" TEXT,
    "creator_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "source_context_id" TEXT,
    "target_context_id" TEXT,
    "connection_type" "ConnectionType",
    "preceding_context_id" TEXT,
    "default_target_id" TEXT,

    CONSTRAINT "contexts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "context_mappings" (
    "id" TEXT NOT NULL,
    "mapping_context_id" TEXT NOT NULL,
    "contained_context_id" TEXT NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "context_mappings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conditional_targets" (
    "id" TEXT NOT NULL,
    "conditional_context_id" TEXT NOT NULL,
    "target_context_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "conditional_targets_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "contexts_slug_key" ON "contexts"("slug");

-- CreateIndex
CREATE INDEX "contexts_context_type_idx" ON "contexts"("context_type");

-- CreateIndex
CREATE INDEX "contexts_creator_id_idx" ON "contexts"("creator_id");

-- CreateIndex
CREATE INDEX "contexts_slug_idx" ON "contexts"("slug");

-- CreateIndex
CREATE INDEX "contexts_source_context_id_idx" ON "contexts"("source_context_id");

-- CreateIndex
CREATE INDEX "contexts_target_context_id_idx" ON "contexts"("target_context_id");

-- CreateIndex
CREATE INDEX "contexts_preceding_context_id_idx" ON "contexts"("preceding_context_id");

-- CreateIndex
CREATE INDEX "context_mappings_mapping_context_id_idx" ON "context_mappings"("mapping_context_id");

-- CreateIndex
CREATE INDEX "context_mappings_contained_context_id_idx" ON "context_mappings"("contained_context_id");

-- CreateIndex
CREATE INDEX "context_mappings_sort_order_idx" ON "context_mappings"("sort_order");

-- CreateIndex
CREATE UNIQUE INDEX "context_mappings_mapping_context_id_contained_context_id_key" ON "context_mappings"("mapping_context_id", "contained_context_id");

-- CreateIndex
CREATE INDEX "conditional_targets_conditional_context_id_idx" ON "conditional_targets"("conditional_context_id");

-- CreateIndex
CREATE INDEX "conditional_targets_target_context_id_idx" ON "conditional_targets"("target_context_id");

-- CreateIndex
CREATE UNIQUE INDEX "conditional_targets_conditional_context_id_target_context_i_key" ON "conditional_targets"("conditional_context_id", "target_context_id");

-- AddForeignKey
ALTER TABLE "contexts" ADD CONSTRAINT "contexts_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contexts" ADD CONSTRAINT "contexts_source_context_id_fkey" FOREIGN KEY ("source_context_id") REFERENCES "contexts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contexts" ADD CONSTRAINT "contexts_target_context_id_fkey" FOREIGN KEY ("target_context_id") REFERENCES "contexts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contexts" ADD CONSTRAINT "contexts_preceding_context_id_fkey" FOREIGN KEY ("preceding_context_id") REFERENCES "contexts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contexts" ADD CONSTRAINT "contexts_default_target_id_fkey" FOREIGN KEY ("default_target_id") REFERENCES "contexts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "context_mappings" ADD CONSTRAINT "context_mappings_mapping_context_id_fkey" FOREIGN KEY ("mapping_context_id") REFERENCES "contexts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "context_mappings" ADD CONSTRAINT "context_mappings_contained_context_id_fkey" FOREIGN KEY ("contained_context_id") REFERENCES "contexts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conditional_targets" ADD CONSTRAINT "conditional_targets_conditional_context_id_fkey" FOREIGN KEY ("conditional_context_id") REFERENCES "contexts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conditional_targets" ADD CONSTRAINT "conditional_targets_target_context_id_fkey" FOREIGN KEY ("target_context_id") REFERENCES "contexts"("id") ON DELETE CASCADE ON UPDATE CASCADE;
