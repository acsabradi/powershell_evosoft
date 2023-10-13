class contact {
        [string] $contactname
        [string] $contactcompany
        [string] $contactphone

        contact ([string] $name, [string] $company, [string] $phone)
        { 
                $this.contactname = $name; 
                $this.contactcompany = $company; 
                $this.contactphone = $phone;
        }
        [string] email() 
        { 
                 return ($this.contactname.Replace(" ",".")) + "@" + $this.contactcompany + ".com"; 
        } 
}


