-- Postgres


CREATE TABLE "advertiser" (
  "id" SERIAL CONSTRAINT "pk_advertiser" PRIMARY KEY,
  "advertiser_id" TEXT NOT NULL
);

CREATE TABLE "publisher" (
  "id" SERIAL CONSTRAINT "pk_publisher" PRIMARY KEY,
  "publisher_id" TEXT NOT NULL
);

CREATE TABLE "website" (
  "url" SERIAL CONSTRAINT "pk_website" PRIMARY KEY,
  "publisher" INTEGER NOT NULL
);

CREATE INDEX "idx_website__publisher" ON "website" ("publisher");

ALTER TABLE "website" ADD CONSTRAINT "fk_website__publisher" FOREIGN KEY ("publisher") REFERENCES "publisher" ("id");

CREATE TABLE "listing" (
  "id" SERIAL CONSTRAINT "pk_listing" PRIMARY KEY,
  "name" VARCHAR(80) NOT NULL,
  "description" VARCHAR(1024) NOT NULL,
  "date_added" TIMESTAMP NOT NULL DEFAULT current_timestamp,
  "expiration_date" DATE,
  "currency" TEXT NOT NULL,
  "price" TEXT NOT NULL,
  "type" TEXT NOT NULL,
  "classtype" TEXT NOT NULL,
  "publisher" INTEGER,
  "website" TEXT,
  "advertiser" INTEGER
);

CREATE INDEX "idx_listing__advertiser" ON "listing" ("advertiser");

CREATE INDEX "idx_listing__publisher" ON "listing" ("publisher");

CREATE INDEX "idx_listing__website" ON "listing" ("website");

ALTER TABLE "listing" ADD CONSTRAINT "fk_listing__advertiser" FOREIGN KEY ("advertiser") REFERENCES "advertiser" ("id");

ALTER TABLE "listing" ADD CONSTRAINT "fk_listing__publisher" FOREIGN KEY ("publisher") REFERENCES "publisher" ("id");

ALTER TABLE "listing" ADD CONSTRAINT "fk_listing__website" FOREIGN KEY ("website") REFERENCES "website" ("url");

CREATE TABLE "contract" (
  "number" SERIAL CONSTRAINT "pk_contract" PRIMARY KEY,
  "name" TEXT NOT NULL,
  "advertiser" INTEGER NOT NULL,
  "publisher" INTEGER NOT NULL,
  "start_date" TIMESTAMP NOT NULL DEFAULT current_timestamp,
  "end_date" TIMESTAMP NOT NULL,
  "currency" TEXT NOT NULL,
  "payout_cap" DECIMAL(12, 2) DEFAULT 6,
  "ad" TEXT NOT NULL,
  "adspace" TEXT NOT NULL
);

CREATE INDEX "idx_contract__ad" ON "contract" ("ad");

CREATE INDEX "idx_contract__adspace" ON "contract" ("adspace");

CREATE INDEX "idx_contract__advertiser" ON "contract" ("advertiser");

CREATE INDEX "idx_contract__publisher" ON "contract" ("publisher");

ALTER TABLE "contract" ADD CONSTRAINT "fk_contract__ad" FOREIGN KEY ("ad") REFERENCES "listing" ("id");

ALTER TABLE "contract" ADD CONSTRAINT "fk_contract__adspace" FOREIGN KEY ("adspace") REFERENCES "listing" ("id");

ALTER TABLE "contract" ADD CONSTRAINT "fk_contract__advertiser" FOREIGN KEY ("advertiser") REFERENCES "advertiser" ("id");

ALTER TABLE "contract" ADD CONSTRAINT "fk_contract__publisher" FOREIGN KEY ("publisher") REFERENCES "publisher" ("id");

CREATE TABLE "invoice" (
  "number" SERIAL CONSTRAINT "pk_invoice" PRIMARY KEY,
  "contract" INTEGER NOT NULL,
  "date" TIMESTAMP NOT NULL DEFAULT current_timestamp,
  "currency" TEXT NOT NULL,
  "amount" DECIMAL(12, 2) NOT NULL,
  "due_date" TIMESTAMP NOT NULL,
  "paid" BOOLEAN NOT NULL DEFAULT true,
  "tx_hash" TEXT NOT NULL
);

CREATE INDEX "idx_invoice__contract" ON "invoice" ("contract");

ALTER TABLE "invoice" ADD CONSTRAINT "fk_invoice__contract" FOREIGN KEY ("contract") REFERENCES "contract" ("number")
