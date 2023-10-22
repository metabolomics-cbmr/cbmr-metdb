export interface DashboardData {
  GRAPH?: {
    id: string;
    link: string;
    tag: string;
  };
  HISTORY: {
    LAST_THREE_MS1: {
      [id: string]: string;
    };
    LAST_THREE_MS2: {
      [id: string]: string;
    };
  };
  MISSING_DATA: {
    [missingData: string]: string;
  };
  STATS: {
    TOTAL_COMPOUNDS: string;
    TOTAL_MS1: string;
    TOTAL_MS2: string;
  };
}
