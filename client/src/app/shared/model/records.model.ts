export interface AllCompoundsRecord {
  'Biospecimen Locations': string;
  'Canonical SMILES': string;
  'Class Chemical Taxonomy': string;
  'Compound Name': string;
  'Extra PubChem Ids': string;
  'HMDB YMDB Id': string;
  'Has Adduct Fa?': Has;
  'Has Adduct H?': Has;
  'Has Adduct K?': Has;
  'Has Adduct Na?': Has;
  'Has Fragment Loss Fa?': Has;
  'Has Fragment Loss H2O': Has;
  'Has Fragment Loss HCOOH?': Has;
  'InChi Key': string;
  'KEGG Id': string;
  'METLIN Id': string;
  'Molecular Formula': string;
  'Mono Molecular Mass': string;
  'PubChem Id': string;
  'PubChem SId': string;
  'PubChem Url': string;
  'Sub Class Chemical Taxonomy': string;
  'Supplier Category No': string;
  'Supplier Product Name': string;
  'Tissue Locations': string;
  cas: string;
  chebi: string;
  id: number;
  name_corrected: string;
  polarity: Polarity;
  smiles: string;
}

export enum Has {
  N = 'N',
  Y = 'Y',
}

export enum Polarity {
  Neg = 'NEG',
  Pos = 'POS',
}
