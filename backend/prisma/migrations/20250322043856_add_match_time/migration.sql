/*
  Warnings:

  - Added the required column `incrementTime` to the `Match` table without a default value. This is not possible if the table is not empty.
  - Added the required column `initialTime` to the `Match` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Match" ADD COLUMN     "incrementTime" INTEGER NOT NULL,
ADD COLUMN     "initialTime" INTEGER NOT NULL,
ADD COLUMN     "timeLeftBlack" INTEGER,
ADD COLUMN     "timeLeftWhite" INTEGER;
