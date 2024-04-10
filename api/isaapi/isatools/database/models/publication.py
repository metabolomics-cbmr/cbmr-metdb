from sqlalchemy import Column, String, ForeignKey, select
from sqlalchemy.orm import relationship, Session

from isatools.model import Publication as PublicationModel
from isatools.database.models.relationships import investigation_publications, study_publications
from isatools.database.utils import Base
from isatools.database.models.utils import make_get_table_method


class Publication(Base):
    """ The SQLAlchemy model for the Publication table """
    __allow_unmapped__ = True
    __tablename__: str = 'publication'

    # Base fields
    publication_id: str = Column(String, primary_key=True)
    author_list: str = Column(String, nullable=True)
    doi: str = Column(String, nullable=True)
    pubmed_id: str = Column(String, nullable=True)
    title: str = Column(String, nullable=True)

    # Relationships: back-ref
    investigations: relationship = relationship(
        'Investigation', secondary=investigation_publications, back_populates='publications'
    )
    studies: relationship = relationship('Study', secondary=study_publications, back_populates='publications')

    # Relationships many-to-one
    status_id: str = Column(String, ForeignKey('ontology_annotation.ontology_annotation_id'))
    status: relationship = relationship('OntologyAnnotation', backref='publications')

    # Relationships
    comments: relationship = relationship('Comment', back_populates='publication')

    def to_json(self) -> dict:
        """ Convert the SQLAlchemy object to a dictionary

        :return: The dictionary representation of the object taken from the database
        """
        return {
            "authorList": self.author_list,
            "doi": self.doi,
            "pubMedID": self.pubmed_id,
            "title": self.title,
            "status": self.status.to_json(),
            "comments": [comment.to_json() for comment in self.comments]
        }


def make_publication_methods():
    """ This function will dynamically add the methods to the Publication class that are required to interact with the
    database. This is done to avoid circular imports and to extra dependencies in the models package. It's called
    in the init of the database models package.
    """
    def to_sql(self, session: Session) -> Publication:
        """ Convert the Publication object to a SQLAlchemy object so that it can be added to the database.

        :param self: the Publication object. Will be injected automatically.
        :param session: the SQLAlchemy session. Will be injected automatically.

        :return: The SQLAlchemy object ready to committed to the database session.
        """

        #print("Publication before query ", self.pubmed_id)

        #20230812 Pravin search publication on basis of id and not doi
        #publication = session.get(Publication, {"pubmed_id":self.pubmed_id})
        #publication = session.query(Publication).get(self.doi)

        stmt = select(Publication).where(Publication.pubmed_id == self.pubmed_id)
        pub = session.execute(stmt)

        pub_row_id = ""        
        for row in pub: 
            pub_row_id =  row[0].publication_id 
            break 
        

        publication = session.query(Publication).get(pub_row_id)
        #publication = session.query(Publication).get({"pubmed_id":"12345678"})

        # #pubdict = pub.mappings().all()
        # print("Rows " , len(pubdict) )
        # publication = PublicationModel()
        #print('In publication type q', type((publication)))
        #publication.from_dict(pubdict)
        

        #publication = session.query(Publication).get(self.pubmed_id)
        
        if publication:
            #print("In publication found ")
            return publication


        #

        #print("In publication 2")
        #publication_id=self.doi,
        #20230812  assign self.id to publication_id instead of self.dopi as originally done
        publication = Publication(
            publication_id=self.id,
            author_list=self.author_list,
            doi=self.doi,
            pubmed_id=self.pubmed_id,
            title=self.title,
            status=self.status.to_sql(session),
            comments=[comment.to_sql() for comment in self.comments]
        )
        session.add(publication)
        session.commit()
        #print('In publication 2')                

        return publication

    setattr(PublicationModel, 'to_sql', to_sql)
    setattr(PublicationModel, 'get_table', make_get_table_method(Publication))
