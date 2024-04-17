import { useState, useEffect } from 'react';
import { Method } from '../model/methods.model';
import {
  getMethods,
} from '../utils/api.utils';


const useMethods = () => {
  const [methods, setMethods] = useState<
    Method[]
  >([]);

  const getMethodsFromAPI = async () => {
    const savedMethods = await getMethods();
    setMethods(savedMethods);
  };

  useEffect(() => {
    getMethodsFromAPI();
  }, []);

  return {
    methods,
    getMethodsFromAPI
  };
};

export default useMethods;
