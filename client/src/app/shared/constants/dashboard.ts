import { DashboardData } from '../model/dashboard.model';

export const DASHBOARD_DATA: DashboardData = {
  // GRAPH_LINK: '/mocks/images/graph2.jpeg',
  GRAPH: {
    id: '1',
    link: '',
    tag: '',
  },
  HISTORY: {
    LAST_THREE_MS1: {
      // '32': 'Loading File Name.xlsx',
      // '33': 'Loading File Name.xlsx',
      // '34': 'Loading File Name.xlsx',
    },
    LAST_THREE_MS2: {
      // '1': 'Loading File Name.mgf',
      // '2': 'Loading File Name.mgf',
      // '3': 'Loading File Name.mgf',
    },
  },
  MISSING_DATA: {
    MISSING_INCHIKEY: '0',
    MISSING_SMILES: '0',
    MISSING_MS2: '0',
    MISSING_CHEBIEY: '0',
    MISSING_URL: '0',
  },
  STATS: {
    TOTAL_COMPOUNDS: '0',
    TOTAL_MS1: '0',
    TOTAL_MS2: '0',
  },
};

export const MOCK_MISSING_DATA = [['', '']];
