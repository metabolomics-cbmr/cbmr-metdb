import Card from '../../atoms/Card';

const TableLayout = ({ children, thead, title }) => {
  return (
    <>
      <div className="d-flex flex-wrap">
        <div className="d-flex justify-content-between w-100 mb-3">
          <span className="table-header-text">{title}</span>
        </div>
        <Card className="p-0 w-100">
          <table className="w-100">
            <thead>
              <tr className="border-bottom">{thead}</tr>
            </thead>
            <tbody>{children}</tbody>
          </table>
        </Card>
      </div>
    </>
  );
};

export default TableLayout;
