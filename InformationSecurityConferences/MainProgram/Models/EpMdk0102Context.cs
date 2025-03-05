using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace MainProgram.Models;

public partial class EpMdk0102Context : DbContext
{
    public EpMdk0102Context()
    {
    }

    public EpMdk0102Context(DbContextOptions<EpMdk0102Context> options)
        : base(options)
    {
    }

    public virtual DbSet<Activity> Activities { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Country> Countries { get; set; }

    public virtual DbSet<Direction> Directions { get; set; }

    public virtual DbSet<Event> Events { get; set; }

    public virtual DbSet<Gender> Genders { get; set; }

    public virtual DbSet<ModeratorEvent> ModeratorEvents { get; set; }

    public virtual DbSet<Person> Persons { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=ep_mdk0102;Username=postgres;Password=12345");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Activity>(entity =>
        {
            entity.HasKey(e => e.IdActivity).HasName("activities_pk");

            entity.ToTable("activities");

            entity.Property(e => e.IdActivity)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id_activity");
            entity.Property(e => e.ActivityName)
                .HasColumnType("character varying")
                .HasColumnName("activity_name");
            entity.Property(e => e.DayNumber).HasColumnName("day_number");
            entity.Property(e => e.IdEvent).HasColumnName("id_event");
            entity.Property(e => e.IdJury1).HasColumnName("id_jury_1");
            entity.Property(e => e.IdJury2).HasColumnName("id_jury_2");
            entity.Property(e => e.IdJury3).HasColumnName("id_jury_3");
            entity.Property(e => e.IdJury4).HasColumnName("id_jury_4");
            entity.Property(e => e.IdJury5).HasColumnName("id_jury_5");
            entity.Property(e => e.IdModerator).HasColumnName("id_moderator");
            entity.Property(e => e.TimeStart).HasColumnName("time_start");

            entity.HasOne(d => d.IdEventNavigation).WithMany(p => p.Activities)
                .HasForeignKey(d => d.IdEvent)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_events_fk");

            entity.HasOne(d => d.IdJury1Navigation).WithMany(p => p.ActivityIdJury1Navigations)
                .HasForeignKey(d => d.IdJury1)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_persons_fk_1");

            entity.HasOne(d => d.IdJury2Navigation).WithMany(p => p.ActivityIdJury2Navigations)
                .HasForeignKey(d => d.IdJury2)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_persons_fk_2");

            entity.HasOne(d => d.IdJury3Navigation).WithMany(p => p.ActivityIdJury3Navigations)
                .HasForeignKey(d => d.IdJury3)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_persons_fk_3");

            entity.HasOne(d => d.IdJury4Navigation).WithMany(p => p.ActivityIdJury4Navigations)
                .HasForeignKey(d => d.IdJury4)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_persons_fk_4");

            entity.HasOne(d => d.IdJury5Navigation).WithMany(p => p.ActivityIdJury5Navigations)
                .HasForeignKey(d => d.IdJury5)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_persons_fk_5");

            entity.HasOne(d => d.IdModeratorNavigation).WithMany(p => p.ActivityIdModeratorNavigations)
                .HasForeignKey(d => d.IdModerator)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("activities_persons_fk");
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.IdCity).HasName("cities_pk");

            entity.ToTable("cities");

            entity.HasIndex(e => e.CityName, "cities_unique").IsUnique();

            entity.Property(e => e.IdCity)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_city");
            entity.Property(e => e.CityImage)
                .HasColumnType("character varying")
                .HasColumnName("city_image");
            entity.Property(e => e.CityName)
                .HasColumnType("character varying")
                .HasColumnName("city_name");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.HasKey(e => e.IdCountry).HasName("countries_pk");

            entity.ToTable("countries");

            entity.HasIndex(e => e.CountryNameEn, "countries_unique_country_name_en").IsUnique();

            entity.HasIndex(e => e.CountryNameRu, "countries_unique_country_name_ru").IsUnique();

            entity.HasIndex(e => e.LetterCode, "countries_unique_letter_code").IsUnique();

            entity.HasIndex(e => e.NumericCode, "countries_unique_numeric_code").IsUnique();

            entity.Property(e => e.IdCountry)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_country");
            entity.Property(e => e.CountryNameEn)
                .HasColumnType("character varying")
                .HasColumnName("country_name_en");
            entity.Property(e => e.CountryNameRu)
                .HasColumnType("character varying")
                .HasColumnName("country_name_ru");
            entity.Property(e => e.LetterCode)
                .HasColumnType("character varying")
                .HasColumnName("letter_code");
            entity.Property(e => e.NumericCode).HasColumnName("numeric_code");
        });

        modelBuilder.Entity<Direction>(entity =>
        {
            entity.HasKey(e => e.IdDirection).HasName("directions_pk");

            entity.ToTable("directions");

            entity.HasIndex(e => e.DirectionName, "directions_unique").IsUnique();

            entity.Property(e => e.IdDirection)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_direction");
            entity.Property(e => e.DirectionName)
                .HasColumnType("character varying")
                .HasColumnName("direction_name");
        });

        modelBuilder.Entity<Event>(entity =>
        {
            entity.HasKey(e => e.IdEvent).HasName("events_pk");

            entity.ToTable("events");

            entity.Property(e => e.IdEvent)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_event");
            entity.Property(e => e.EventDate).HasColumnName("event_date");
            entity.Property(e => e.EventImage)
                .HasColumnType("character varying")
                .HasColumnName("event_image");
            entity.Property(e => e.EventName)
                .HasColumnType("character varying")
                .HasColumnName("event_name");
            entity.Property(e => e.IdCity).HasColumnName("id_city");
            entity.Property(e => e.IdWinner).HasColumnName("id_winner");
            entity.Property(e => e.LengthDays).HasColumnName("length_days");

            entity.HasOne(d => d.IdCityNavigation).WithMany(p => p.Events)
                .HasForeignKey(d => d.IdCity)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("events_cities_fk");

            entity.HasOne(d => d.IdWinnerNavigation).WithMany(p => p.Events)
                .HasForeignKey(d => d.IdWinner)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("events_persons_fk");
        });

        modelBuilder.Entity<Gender>(entity =>
        {
            entity.HasKey(e => e.IdGender).HasName("genders_pk");

            entity.ToTable("genders");

            entity.HasIndex(e => e.GenderName, "genders_unique").IsUnique();

            entity.Property(e => e.IdGender)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_gender");
            entity.Property(e => e.GenderName)
                .HasColumnType("character varying")
                .HasColumnName("gender_name");
        });

        modelBuilder.Entity<ModeratorEvent>(entity =>
        {
            entity.HasKey(e => e.IdModeratorEvent).HasName("moderator_events_pk");

            entity.ToTable("moderator_events");

            entity.HasIndex(e => e.ModeratorEventName, "moderator_events_unique").IsUnique();

            entity.Property(e => e.IdModeratorEvent)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_moderator_event");
            entity.Property(e => e.ModeratorEventName)
                .HasColumnType("character varying")
                .HasColumnName("moderator_event_name");
        });

        modelBuilder.Entity<Person>(entity =>
        {
            entity.HasKey(e => e.IdPerson).HasName("persons_pk");

            entity.ToTable("persons");

            entity.HasIndex(e => e.IdUser, "persons_unique").IsUnique();

            entity.Property(e => e.IdPerson)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id_person");
            entity.Property(e => e.Birthday).HasColumnName("birthday");
            entity.Property(e => e.IdCountry).HasColumnName("id_country");
            entity.Property(e => e.IdDirection).HasColumnName("id_direction");
            entity.Property(e => e.IdGender).HasColumnName("id_gender");
            entity.Property(e => e.IdModeratorEvent).HasColumnName("id_moderator_event");
            entity.Property(e => e.IdUser).HasColumnName("id_user");
            entity.Property(e => e.PersonFirstName)
                .HasColumnType("character varying")
                .HasColumnName("person_first_name");
            entity.Property(e => e.PersonImage)
                .HasColumnType("character varying")
                .HasColumnName("person_image");
            entity.Property(e => e.PersonLastName)
                .HasColumnType("character varying")
                .HasColumnName("person_last_name");
            entity.Property(e => e.PersonPatronymic)
                .HasColumnType("character varying")
                .HasColumnName("person_patronymic");
            entity.Property(e => e.PhoneNumber)
                .HasColumnType("character varying")
                .HasColumnName("phone_number");

            entity.HasOne(d => d.IdCountryNavigation).WithMany(p => p.People)
                .HasForeignKey(d => d.IdCountry)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("persons_countries_fk");

            entity.HasOne(d => d.IdDirectionNavigation).WithMany(p => p.People)
                .HasForeignKey(d => d.IdDirection)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("persons_directions_fk");

            entity.HasOne(d => d.IdGenderNavigation).WithMany(p => p.People)
                .HasForeignKey(d => d.IdGender)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("persons_genders_fk");

            entity.HasOne(d => d.IdModeratorEventNavigation).WithMany(p => p.People)
                .HasForeignKey(d => d.IdModeratorEvent)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("persons_moderator_events_fk");

            entity.HasOne(d => d.IdUserNavigation).WithOne(p => p.Person)
                .HasForeignKey<Person>(d => d.IdUser)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("persons_users_fk");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.IdRole).HasName("roles_pk");

            entity.ToTable("roles");

            entity.HasIndex(e => e.RoleName, "roles_unique").IsUnique();

            entity.Property(e => e.IdRole)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id_role");
            entity.Property(e => e.RoleName)
                .HasColumnType("character varying")
                .HasColumnName("role_name");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.IdUser).HasName("users_pk");

            entity.ToTable("users");

            entity.HasIndex(e => e.Email, "users_unique").IsUnique();

            entity.Property(e => e.IdUser)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id_user");
            entity.Property(e => e.Email)
                .HasColumnType("character varying")
                .HasColumnName("email");
            entity.Property(e => e.IdRole)
                .HasDefaultValue(1)
                .HasColumnName("id_role");
            entity.Property(e => e.Password)
                .HasColumnType("character varying")
                .HasColumnName("password");

            entity.HasOne(d => d.IdRoleNavigation).WithMany(p => p.Users)
                .HasForeignKey(d => d.IdRole)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("users_roles_fk");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
