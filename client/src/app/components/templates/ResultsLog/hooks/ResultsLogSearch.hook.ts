import { useState, useRef, useCallback, useEffect } from 'react';
import { ResultLog } from '../../../../shared/model/results.model';
import { formatFileName } from '../../../atoms/FileName/FileName';

const useResultsLogSearch = (results: ResultLog[]) => {
  const [filteredResults, setFilteredResults] = useState([...results]);
  const searchTermRef = useRef('');
  const onSearch = useCallback(
    (searchTerm) => {
      searchTermRef.current = searchTerm;
      const searchResult = [
        ...results.filter((resultLog) =>
          [resultLog.id, formatFileName(resultLog.file_name)]
            .map((value) => value.toString().toLocaleLowerCase())
            .some((value) =>
              value.toString().includes(searchTerm.toLocaleLowerCase()),
            ),
        ),
      ];
      setFilteredResults(searchResult);
    },
    [results],
  );

  useEffect(() => {
    onSearch(searchTermRef.current);
  }, [results, onSearch]);

  return { filteredResults, onSearch };
};

export default useResultsLogSearch;
