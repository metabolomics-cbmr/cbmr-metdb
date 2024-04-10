import {getInvContactData} from '../../../../shared/utils/api.utils';
import LazyCollapsible from '../../../atoms/LazyCollapsible';
import { useEffect, useState, useCallback  } from "react" ;
import Card from '../../../atoms/Card';
import '../ISADataRetrieval.style.scss';
import { Contact } from '../../../../shared/model/isadata-details.model';


// const StudyRow = ({studyId, title, description, identifier, 
//   filename, submissionDate, publicReleaseDate} : {




const InvContactRow = ({name, email, phone,  fax, address, affiliation, role }) => {

      return (
        <>
          <tr >


            <td className="p-3 table-text ">{name}</td>
            <td className="p-3 table-text">{email}</td>
            <td className="p-3 table-text">{phone}</td>
            <td className="p-3 table-text">{fax}</td>
            <td className="p-3 table-text">{address}</td>
            <td className="p-3 table-text">{affiliation}</td>
            <td className="p-3 table-text">{role}</td>

          </tr>

      </>
    );

}


const InvContacts = ({investigationId}) => {
  const [invContacts, setInvContacts] = useState<Contact[]>([]);


  const getInvContacts = useCallback(async  () => {
      try {
          const invPublications =   await getInvContactData(investigationId);
      
     
          setInvContacts(invPublications["contacts"]) ; 

      } catch (error) {
          alert('Could not get Investigation Contact Details');
          console.log({ isaDataError: error });
        }
    }, [investigationId]) ;

  
    useEffect(() => {
      if (!investigationId) {
        alert('Invalid Investigation Id');
      } else {
        getInvContacts();
      }
    },[investigationId,  getInvContacts])


//     <div className="d-flex justify-content-between w-100 mb-3">
//     <span className="table-header-text ">Study : {studyId}</span> 
//    {/* <span className="view-all">View All</span> */}
//  </div>


    return (
      <div className="d-flex flex-wrap borderless">

        <Card className="p-0 w-100">
          <table className="w-100">
            <thead>
              <tr className="border-bottom">

                <th className="p-3 top-align ">Name</th>
                <th className="p-3 top-align ">Email</th>
                <th className="p-3 top-align ">Phone</th>
                <th className="p-3 top-align ">Fax</th>
                <th className="p-3 top-align ">Address</th>
                <th className="p-3 top-align ">Affiliation</th>
                <th className="p-3 top-align ">Role</th>


              </tr>
            </thead>
            <tbody>

            {invContacts ?  invContacts.map((item, i) => (
                
                <InvContactRow 
                name = {item["first_name"] + " " + item["mid_initials"] + " " + item["lst_name"] } 
                email = {item["email"]}
                phone = {item["phone"]} 
                fax = {item["fax"]} 
                address= {item["address"]} 
                affiliation= {item["affiliation"]} 
                role= {item["person_role"]} 
              
              />

            )) : ""
            }

            </tbody>
          </table>
          </Card>

      </div>
    );

}

export default  InvContacts ;