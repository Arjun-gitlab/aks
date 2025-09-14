const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());
let patients = [
  { id: '1', name: 'John Doe', age: 30 },
  { id: '2', name: 'Jane Smith', age: 25 }
];
app.get('/', (req, res) => res.json({status:'ok', service:'patient'}));
app.get('/patients', (req,res) => res.json(patients));
app.post('/patients', (req,res) => { const p = req.body; p.id = (patients.length+1).toString(); patients.push(p); res.status(201).json(p); });
app.listen(port, ()=>console.log(`patient listening ${port}`));