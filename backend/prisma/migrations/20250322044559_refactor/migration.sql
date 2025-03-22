/*
  Warnings:

  - The values [BLACK,WHITE,DRAW] on the enum `Winner` will be removed. If these variants are still used in the database, this will fail.
  - The `endReason` column on the `Match` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Winner_new" AS ENUM ('black', 'white', 'draw');
ALTER TABLE "Match" ALTER COLUMN "winner" TYPE "Winner_new" USING ("winner"::text::"Winner_new");
ALTER TYPE "Winner" RENAME TO "Winner_old";
ALTER TYPE "Winner_new" RENAME TO "Winner";
DROP TYPE "Winner_old";
COMMIT;

-- AlterTable
ALTER TABLE "Match" DROP COLUMN "endReason",
ADD COLUMN     "endReason" TEXT;

-- DropEnum
DROP TYPE "EndReason";
