import React from 'react';
import './UnknownCompoundDetectionConfig.style.scss';
import SettingsFormInput from '../SettingsFormInput/SettingsFormInput';

const UnknownCompoundDetectionConfig = ({
  comparisionSettings = {
    name: '',
    matching_peaks: '1',
    matching_score: '0.75',
    pep_mass_tolerance: [-1, 1],
  },
  updateComparisonSettings = null,
}: {
  comparisionSettings: any;
  updateComparisonSettings?: any;
}) => {
  return (
    <table className="w-100">
      <thead>
        <tr className="border-bottom">
          <th className="p-3">Description</th>
          <th className="p-3">Threshold/Value</th>
        </tr>
      </thead>
      <tbody>
        <tr className="border-bottom table__row--hoverable">
          <td className="p-3 table-text">Name of This Config</td>
          <td className="p-3 table-text">
            <SettingsFormInput
              placeholder="What would you like to call this config?"
              value={comparisionSettings.name}
              onChange={(name) => updateComparisonSettings?.({ name })}
              type="string"
              disabled={!updateComparisonSettings}
            />
          </td>
        </tr>
        <tr className="border-bottom table__row--hoverable">
          <td className="p-3 table-text">Minimum number of matching peaks</td>
          <td className="p-3 table-text">
            <SettingsFormInput
              value={comparisionSettings.matching_peaks}
              min="1"
              max="100"
              step="1"
              onChange={(matching_peaks) => {
                updateComparisonSettings?.({ matching_peaks });
              }}
              disabled={!updateComparisonSettings}
            />
          </td>
        </tr>
        <tr className="border-bottom table__row--hoverable">
          <td className="p-3 table-text">Matching score threshold </td>
          <td className="p-3 table-text">
            <SettingsFormInput
              value={comparisionSettings.matching_score}
              min="0.10"
              max="1.00"
              onChange={(matching_score) => {
                updateComparisonSettings?.({ matching_score });
              }}
              disabled={!updateComparisonSettings}
            />
          </td>
        </tr>
        <tr>
          <td className="p-3 table-text" rowSpan={2}>
            Range of Precursor mass tolerance for selecting reference compounds
          </td>
          <td className="p-3 table-text">
            <table className="w-100">
              <tbody>
                <tr className="border-bottom">
                  <td className="p-3 table-text">From</td>
                  <td className="p-3 table-text">
                    <SettingsFormInput
                      value={comparisionSettings.pep_mass_tolerance[0]}
                      onChange={(pep_mass_tolerance_lower) => {
                        updateComparisonSettings?.({
                          pep_mass_tolerance: [
                            pep_mass_tolerance_lower,
                            comparisionSettings.pep_mass_tolerance[1],
                          ],
                        });
                      }}
                      disabled={!updateComparisonSettings}
                    />
                  </td>
                </tr>
                <tr>
                  <td className="p-3 table-text">To</td>
                  <td className="p-3 table-text">
                    <SettingsFormInput
                      value={comparisionSettings.pep_mass_tolerance[1]}
                      onChange={(pep_mass_tolerance_higher) => {
                        updateComparisonSettings?.({
                          pep_mass_tolerance: [
                            comparisionSettings.pep_mass_tolerance[0],
                            pep_mass_tolerance_higher,
                          ],
                        });
                      }}
                      disabled={!updateComparisonSettings}
                    />
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>
  );
};

export default UnknownCompoundDetectionConfig;
