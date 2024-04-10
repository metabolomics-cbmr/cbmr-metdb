export const MISSING_COMPOUNDS: {
  type: string;
  missingCompounds: number;
}[] = [
  {
    type: 'Number of compounds where InChI key is missing',
    missingCompounds: 20,
  },
  {
    type: 'Number of compounds SMILES is missing',
    missingCompounds: 20,
  },
  {
    type: 'Number of compounds with missing MS2 data',
    missingCompounds: 20,
  },
  {
    type: 'Number of compounds where ChEBI key is missing',
    missingCompounds: 20,
  },
  {
    type: 'Number of compounds where url is missing',
    missingCompounds: 20,
  },
];
