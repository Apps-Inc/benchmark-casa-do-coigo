using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Models
{
    public abstract class Entity
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; private set; }

        [Column("time_registered")]
        public DateTime RegisterTime { get; private set; }

        protected Entity(int id, DateTime registerTime)
        {
            Id = id;
            RegisterTime = registerTime;
        }

        protected Entity() : this(0, DateTime.Now)
        {
        }
    }
}
