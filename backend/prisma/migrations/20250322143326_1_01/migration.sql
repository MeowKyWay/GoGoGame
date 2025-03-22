/*
  Warnings:

  - Made the column `winner` on table `Match` required. This step will fail if there are existing NULL values in that column.
  - Made the column `blackScore` on table `Match` required. This step will fail if there are existing NULL values in that column.
  - Made the column `whiteScore` on table `Match` required. This step will fail if there are existing NULL values in that column.
  - Made the column `timeLeftBlack` on table `Match` required. This step will fail if there are existing NULL values in that column.
  - Made the column `timeLeftWhite` on table `Match` required. This step will fail if there are existing NULL values in that column.
  - Made the column `endReason` on table `Match` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Match" ALTER COLUMN "winner" SET NOT NULL,
ALTER COLUMN "blackScore" SET NOT NULL,
ALTER COLUMN "whiteScore" SET NOT NULL,
ALTER COLUMN "timeLeftBlack" SET NOT NULL,
ALTER COLUMN "timeLeftWhite" SET NOT NULL,
ALTER COLUMN "endReason" SET NOT NULL;
