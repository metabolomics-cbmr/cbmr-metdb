"""create configs table

Revision ID: 81503ebcd8f2
Revises: 
Create Date: 2023-03-28 16:32:28.107526

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '81503ebcd8f2'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    tconfig = op.create_table(
        'Configs',
        sa.Column('id', sa.Integer, autoincrement=True, primary_key=True),
        sa.Column('name', sa.String(50), nullable=True),
        sa.Column('type', sa.String(50), nullable=False),
        sa.Column('config', sa.JSON, nullable=False)
    )

    #op.execute(r"insert into Configs (name, type, config)  values('first', 'DEFAULT', {'matching_peaks':'1', 'matching_score':'0.75', 'pep_mass_tolerance':[-1,1]})")

    op.bulk_insert(tconfig,
    [
        {'name':'default', 'type':'DEFAULT', 
                'config':{'matching_peaks':'1', 'matching_score':'0.75', 'pep_mass_tolerance':[-1,1]}}
    ]
    )
# sa.Column('num1', sa.Number(6,2)), 
#         sa.Column('num2', sa.Number(6,2)), 
#         sa.Column("txt1", sa.String(50), 
#         sa.Column("txt2", sa.String(50)),
#         sa.Column("dt1", sa.Date)),
#         sa.Column("dt2", sa.Date)

 

def downgrade() -> None:
    pass
