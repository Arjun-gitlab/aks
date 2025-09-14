const express = require('express');
const app = express();
const port = process.env.PORT || 3001;
app.use(express.json());
let appointments = [
  { id: '1', patientId: '1', date: '2025-09-15', doctor: 'Dr. Adams' },
  { id: '2', patientId: '2', date: '2025-09-20', doctor: 'Dr. Brown' }
];
app.get('/', (req,res) => res.json({status:'ok', service:'appointment'}));
app.get('/appointments', (req,res) => res.json(appointments));
app.post('/appointments', (req,res) => { const a=req.body; a.id=(appointments.length+1).toString(); appointments.push(a); res.status(201).json(a); });
app.listen(port, () => console.log(`appointment listening ${port}`));