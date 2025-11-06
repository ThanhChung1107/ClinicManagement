package com.clinic.model.bean;

// ========== Medicine.java ==========
public class Medicine {
    private int medicineId;
    private String name;
    private String unit;
    private double price;
    
    public Medicine() {}
    
    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}