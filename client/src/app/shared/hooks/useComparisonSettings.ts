import { useState, useEffect } from 'react';
import { ComparisionSettings } from '../model/comparision.model';
import {
  changeCompatisonSettingStatus,
  getComparisionSettings,
} from '../utils/api.utils';

const useComparisonSettings = () => {
  const [comparisionSettings, setComparisionSettings] = useState<
    ComparisionSettings[]
  >([]);

  const getComparisionSettingsFromAPI = async () => {
    const savedConfigs = await getComparisionSettings();
    setComparisionSettings(savedConfigs);
  };

  useEffect(() => {
    getComparisionSettingsFromAPI();
  }, []);

  const changeConfigStatus = async (config: ComparisionSettings) => {
    await changeCompatisonSettingStatus(config.id, !config.active);
    config.active = false;
    setComparisionSettings([...comparisionSettings]);
  };

  return {
    comparisionSettings,
    getComparisionSettingsFromAPI,
    changeConfigStatus,
  };
};

export default useComparisonSettings;
