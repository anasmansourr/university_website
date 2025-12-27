// Quick migration script to add grade_released column
const mysql = require('mysql2/promise');

async function runMigration() {
  let connection;
  try {
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || 'anastamer123',
      database: process.env.DB_NAME || 'university',
      multipleStatements: true
    });

    console.log('Connected to database. Running migration...');
    
    // Check if column exists first
    const [columns] = await connection.query(`
      SELECT COLUMN_NAME 
      FROM INFORMATION_SCHEMA.COLUMNS 
      WHERE TABLE_SCHEMA = ? 
      AND TABLE_NAME = 'enrollments' 
      AND COLUMN_NAME = 'grade_released'
    `, [process.env.DB_NAME || 'university']);

    if (columns.length > 0) {
      console.log('✓ Column grade_released already exists. Migration not needed.');
    } else {
      await connection.query(`
        ALTER TABLE enrollments 
        ADD COLUMN grade_released TINYINT(1) DEFAULT 0
      `);
      console.log('✓ Successfully added grade_released column to enrollments table!');
    }

    console.log('Migration completed successfully!');
    process.exit(0);
  } catch (error) {
    if (error.code === 'ER_DUP_FIELDNAME') {
      console.log('✓ Column grade_released already exists. Migration not needed.');
      process.exit(0);
    } else {
      console.error('Migration failed:', error.message);
      process.exit(1);
    }
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

runMigration();

