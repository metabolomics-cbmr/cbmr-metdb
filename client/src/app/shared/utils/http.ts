const get = <T = any>(url: string) =>
  fetch(url).then(async (response) => {
    if (response.ok) {
      return response.json() as Promise<T>;
    } else {
      throw new Error('Something went wrong');
    }
  });

const getFile = (url: string) => fetch(url).then((response) => response.blob());

const post = <T = any>(url: string, data: any) =>
  fetch(url, {
    method: 'POST',
    body: data,
  }).then(async (response) => {
    if (response.ok) {
      return response.json() as Promise<T>;
    } else {
      const body = await response.json();
      const status = response.status;
      const error = JSON.stringify({ body, status });
      throw new Error(error);
    }
  });

const deleteRequest = <T = any>(url: string) =>
  fetch(url, { method: 'DELETE' }).then(async (response) => {
    if (response.ok) {
      return response.json() as Promise<T>;
    } else {
      throw new Error('Something went wrong');
    }
  });

const http = {
  get,
  getFile,
  post,
  delete: deleteRequest,
};

export default http;
