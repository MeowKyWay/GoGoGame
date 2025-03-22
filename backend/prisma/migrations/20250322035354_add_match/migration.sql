-- CreateEnum
CREATE TYPE "Winner" AS ENUM ('BLACK', 'WHITE', 'DRAW');

-- CreateEnum
CREATE TYPE "EndReason" AS ENUM ('NORMAL', 'TIMEOUT', 'RESIGN', 'DISCONNECT');

-- CreateTable
CREATE TABLE "Match" (
    "id" SERIAL NOT NULL,
    "blackPlayerId" INTEGER,
    "whitePlayerId" INTEGER,
    "winner" "Winner",
    "endReason" "EndReason",
    "blackScore" INTEGER,
    "whiteScore" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Match_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Match" ADD CONSTRAINT "Match_blackPlayerId_fkey" FOREIGN KEY ("blackPlayerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Match" ADD CONSTRAINT "Match_whitePlayerId_fkey" FOREIGN KEY ("whitePlayerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
