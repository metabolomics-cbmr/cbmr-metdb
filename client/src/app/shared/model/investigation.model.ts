import { IStudyType } from '.';
import { STUDY_TYPES } from '../constants';
import { v4 as uuidv4 } from 'uuid';

/**
 * Interfaces
 */

export type OntologyAnnotation = string;

export interface IObjectType {
  id: string;
  name: string;
}

export interface MaterialObject {
  name: string;
  objectType: string;
  materialType: string;
  accessRights: DocumentLicense[];
}

export interface Publication {}

export interface DocumentLicense {
  licenseName: string;
  owners: Person[];
}

export interface BioMaterialObject extends MaterialObject {
  objectType: string;
  materialType: string;
  organism: string;
  organismAnnotation: OntologyAnnotation;
}

export type AssayObject = MaterialObject | BioMaterialObject;

export interface TypeField {
  name: string;
  annotation: OntologyAnnotation;
}

export interface Assay {
  id: string;
  title: string;
  startDate: Date;
  endDate: Date;
  runOrder: string;
  performer: Person;
  cost: string;
  inputs: AssayObject[];
  outputs: AssayObject[];
  measureMentType: TypeField;
  technologyType: TypeField;
  technologyPlatform: string;
}

export interface Study {
  id: string;
  title: string;
  description: string;
  publications: Publication[];
  contacts: Person[];
  studyType: IStudyType;
  designType: OntologyAnnotation;
  factorName: string;
  factorType: OntologyAnnotation;
  protocols: Protocol[];
  assays: Assay[];
}

export interface Investigation {
  id: string;
  title: string;
  description: string;
  submissionDate: Date;
  publicReleaseDate: Date;
  publications: Publication[];
  isaDocumentLicenses: DocumentLicense[];
  studies: Study[];
}

export class MaterialObject {
  name = '';
  objectType = 'MATERIAL_OBJECT';
  materialType = 'ABIOTIC_MATERIAL';
  accessRights: DocumentLicense[] = [new DocumentLicense()];
}
export class Publication {}

export class DocumentLicense {
  licenseName = '';
  owners: Person[] = [new Person()];
}

export class BioMaterialObject extends MaterialObject {
  objectType = 'BIO_MATERIAL_OBJECT';
  materialType = 'BIO_MATERIAL';
  organism = '';
  organismAnnotation: OntologyAnnotation = '';
}

export class TypeField {
  name = '';
  annotation: OntologyAnnotation = '';
}

export class Person {}

export class Protocol {}
export class Assay {
  id = uuidv4();
  title = 'New Assay';
  startDate = new Date();
  endDate = new Date();
  runOrder = '';
  performer = new Person();

  cost = '';

  inputs: AssayObject[] = [new MaterialObject()];
  outputs: AssayObject[] = [new MaterialObject()];

  measureMentType = new TypeField();
  technologyType = new TypeField();
  technologyPlatform = '';
}

export class Study {
  id = uuidv4();
  title = 'New Study';
  description = '';
  publications: Publication[] = [new Publication()];
  contacts: Person[] = [new Person()];
  studyType: IStudyType = STUDY_TYPES[0];

  designType: OntologyAnnotation = '';
  factorName = '';
  factorType: OntologyAnnotation = '';
  protocols: Protocol[] = [new Protocol()];
  assays: Assay[] = [new Assay()];
}

export class Investigation {
  id = uuidv4();
  title = '';
  description = '';
  submissionDate = new Date();
  publicReleaseDate = new Date();
  publications: Publication[] = [new Publication()];

  isaDocumentLicenses: DocumentLicense[] = [new DocumentLicense()];

  studies: Study[] = [new Study()];

  currentActiveItem = this.id;
}
