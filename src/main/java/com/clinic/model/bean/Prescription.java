package com.clinic.model.bean;
public class Prescription {
    private int prescriptionId;
    private int examId;
    private int medicineId;
    private int quantity;
    private String dosage;
    
    // Thông tin bổ sung
    private String medicineName;
    private String unit;
    private double price;
    
    public Prescription() {}
    
    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }
    
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    
    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }
    
    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }
    
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}