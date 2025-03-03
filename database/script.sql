
CREATE FUNCTION public.check_id_direction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_role INT;
BEGIN
    -- Получаем роль пользователя через id_user
    SELECT u.id_role INTO user_role
    FROM users u
    WHERE u.id_user = NEW.id_user;

    -- Если пользователь НЕ Жюри (2) и НЕ Модератор (4), запрещаем заполнение id_direction
    IF NEW.id_direction IS NOT NULL AND user_role NOT IN (2, 4) THEN
        RAISE EXCEPTION 'Только Жюри (2) и Модератор (4) могут заполнять id_direction!';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_id_direction() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16437)
-- Name: check_id_moderator_event(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_id_moderator_event() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_role INT;
BEGIN
    -- Получаем роль пользователя
    SELECT u.id_role INTO user_role
    FROM users u
    WHERE u.id_user = NEW.id_user;

    -- Если пользователь НЕ Модератор (4), запрещаем заполнение id_moderator_event
    IF NEW.id_moderator_event IS NOT NULL AND user_role <> 4 THEN
        RAISE EXCEPTION 'Только Модератор (4) может заполнять id_moderator_event!';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_id_moderator_event() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 16545)
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activities (
    id_activity uuid DEFAULT gen_random_uuid() NOT NULL,
    activity_name character varying NOT NULL,
    day_number integer NOT NULL,
    time_start time without time zone NOT NULL,
    id_moderator uuid NOT NULL,
    id_jury_1 uuid,
    id_jury_2 uuid,
    id_jury_3 uuid,
    id_jury_4 uuid,
    id_jury_5 uuid,
    id_event integer NOT NULL
);


ALTER TABLE public.activities OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16452)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id_city integer NOT NULL,
    city_name character varying NOT NULL,
    city_image character varying
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16451)
-- Name: cities_id_city_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cities ALTER COLUMN id_city ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cities_id_city_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16462)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id_country integer NOT NULL,
    country_name_ru character varying NOT NULL,
    country_name_en character varying NOT NULL,
    numeric_code integer NOT NULL,
    letter_code character varying NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16461)
-- Name: countries_id_country_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ALTER COLUMN id_country ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_id_country_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16488)
-- Name: directions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directions (
    id_direction integer NOT NULL,
    direction_name character varying NOT NULL
);


ALTER TABLE public.directions OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16487)
-- Name: directions_id_direction_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.directions ALTER COLUMN id_direction ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.directions_id_direction_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16528)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id_event integer NOT NULL,
    event_name character varying NOT NULL,
    event_date date NOT NULL,
    length_days integer NOT NULL,
    id_city integer NOT NULL,
    event_image character varying,
    id_winner uuid
);


ALTER TABLE public.events OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16527)
-- Name: events_id_event_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.events ALTER COLUMN id_event ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.events_id_event_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16478)
-- Name: genders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genders (
    id_gender integer NOT NULL,
    gender_name character varying NOT NULL
);


ALTER TABLE public.genders OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16477)
-- Name: genders_id_gender_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.genders ALTER COLUMN id_gender ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.genders_id_gender_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16498)
-- Name: moderator_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moderator_events (
    id_moderator_event integer NOT NULL,
    moderator_event_name character varying NOT NULL
);


ALTER TABLE public.moderator_events OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16497)
-- Name: moderator_events_id_moderator_event_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.moderator_events ALTER COLUMN id_moderator_event ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.moderator_events_id_moderator_event_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16415)
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    id_person uuid DEFAULT gen_random_uuid() NOT NULL,
    person_last_name character varying NOT NULL,
    person_first_name character varying NOT NULL,
    person_patronymic character varying NOT NULL,
    birthday date NOT NULL,
    id_country integer NOT NULL,
    phone_number character varying NOT NULL,
    person_image character varying,
    id_user uuid NOT NULL,
    id_gender integer NOT NULL,
    id_direction integer,
    id_moderator_event integer,
    CONSTRAINT chk_phone_format CHECK (((phone_number)::text ~ '^7\(\d{3}\)\d{3}-\d{2}-\d{2}$'::text))
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16400)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_role integer NOT NULL,
    role_name character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16399)
-- Name: roles_id_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id_role ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    id_role integer DEFAULT 1 NOT NULL,
    CONSTRAINT chk_email_format CHECK (((email)::text ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5012 (class 0 OID 16545)
-- Dependencies: 233
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.activities VALUES ('cc263ea5-2143-441a-ae08-91018bf69d8b', 'ТОП 50 ', 1, '09:00:00', '644e58d7-2dc4-4e10-9cac-034b96e26068', '07a4677b-dded-4cf7-9f1d-ecbefc0b60ea', '433ff0a2-d74c-4c53-af85-062481fd430b', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', NULL, 1);
INSERT INTO public.activities VALUES ('c47489c3-37d1-4276-8086-34ffa9904375', 'Перспективные направления IT', 2, '10:45:00', '6f14b209-ae8f-41e8-8922-0d7bca67b2b4', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '13145872-ae2a-41cc-b9d7-7feb84170d61', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 1);
INSERT INTO public.activities VALUES ('953ff194-5eb1-432c-99c9-956fb9826425', 'Современные технологии', 2, '12:30:00', '5f71c4ce-afa7-44be-bb4d-0e3dc08cf159', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'eb7588c2-233f-4977-87f8-062c379f6680', '42c4e5cf-4346-4678-9e22-bd432517b839', '13145872-ae2a-41cc-b9d7-7feb84170d61', 1);
INSERT INTO public.activities VALUES ('cf236b1c-f4c0-400f-a485-e604f8ddfa42', 'Что такое IOT?', 1, '09:00:00', '50589cda-d271-4c5e-8c52-6cc718026724', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '07a4677b-dded-4cf7-9f1d-ecbefc0b60ea', '433ff0a2-d74c-4c53-af85-062481fd430b', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', 4);
INSERT INTO public.activities VALUES ('e7add937-8021-4331-99c1-57e87fd4a420', 'Для чего это нужно?', 2, '10:45:00', '3d8b4f3e-d657-4acc-b04a-b54c10a837a5', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '13145872-ae2a-41cc-b9d7-7feb84170d61', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', 4);
INSERT INTO public.activities VALUES ('927a8e4a-9577-44fc-a37a-52d8991f49de', 'Новые продукты и версии', 2, '12:30:00', '7b8fe21f-ca92-4647-bcd1-fc9416f1e943', '433ff0a2-d74c-4c53-af85-062481fd430b', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'eb7588c2-233f-4977-87f8-062c379f6680', '42c4e5cf-4346-4678-9e22-bd432517b839', 4);
INSERT INTO public.activities VALUES ('146238ea-bed6-4bb1-bb48-f4ab69d9a568', 'Как составить план?', 1, '09:00:00', '855d68c9-1569-403c-b521-9613006b67b5', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '07a4677b-dded-4cf7-9f1d-ecbefc0b60ea', '433ff0a2-d74c-4c53-af85-062481fd430b', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 5);
INSERT INTO public.activities VALUES ('b827b0e5-c66d-44a4-bc9f-d82b2beaea16', 'Что такое план?', 2, '10:45:00', '0e1938fe-b370-46cf-aa10-250646a3c26a', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '13145872-ae2a-41cc-b9d7-7feb84170d61', 5);
INSERT INTO public.activities VALUES ('56bbfde5-752b-4635-9c11-93bdf829db90', 'Must Have 21 века', 2, '12:30:00', 'e9b939f6-37fd-46d9-9540-21632bea1c29', '433ff0a2-d74c-4c53-af85-062481fd430b', '42c4e5cf-4346-4678-9e22-bd432517b839', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'eb7588c2-233f-4977-87f8-062c379f6680', 5);
INSERT INTO public.activities VALUES ('e2da48ef-be93-40d9-ab8a-fc178a732f73', 'Управление знаниями', 1, '09:00:00', 'be6432fe-e82f-4c7b-8dbf-007335539578', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '07a4677b-dded-4cf7-9f1d-ecbefc0b60ea', '433ff0a2-d74c-4c53-af85-062481fd430b', 6);
INSERT INTO public.activities VALUES ('8456a2aa-8a20-48d5-84dc-c5243758b65c', 'Коммуникативные неудачи', 1, '10:45:00', 'ea482ffe-6b3f-48cc-a7de-27c95a24a10f', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '13145872-ae2a-41cc-b9d7-7feb84170d61', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 6);
INSERT INTO public.activities VALUES ('c855cd5e-5b38-4bad-89a2-24f749a495b6', 'Дизайн-мышление', 2, '12:30:00', 'c9e4d29f-8b56-4c90-99ed-2e3adb836dbc', '42c4e5cf-4346-4678-9e22-bd432517b839', '433ff0a2-d74c-4c53-af85-062481fd430b', 'eb7588c2-233f-4977-87f8-062c379f6680', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '13145872-ae2a-41cc-b9d7-7feb84170d61', 6);
INSERT INTO public.activities VALUES ('5ea092c0-f224-4cde-aa03-bdfa95e00428', 'Технические собеседования', 1, '09:00:00', 'e8e5659f-604f-44e8-8ede-b5b1a44dfeb9', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '433ff0a2-d74c-4c53-af85-062481fd430b', '07a4677b-dded-4cf7-9f1d-ecbefc0b60ea', 7);
INSERT INTO public.activities VALUES ('eb7203a9-38be-4738-8b7a-b619ff7e0826', 'Исследование рынка', 2, '10:45:00', '451b5292-87e2-4d79-826f-abab508269db', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '13145872-ae2a-41cc-b9d7-7feb84170d61', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', 7);
INSERT INTO public.activities VALUES ('6fe8b6a5-de01-48cd-a307-3e0ca939cb61', 'Подготовка специалистов', 3, '12:30:00', '9447c00e-8628-47b8-8514-051cc644b6ea', '433ff0a2-d74c-4c53-af85-062481fd430b', 'eb7588c2-233f-4977-87f8-062c379f6680', '42c4e5cf-4346-4678-9e22-bd432517b839', '13145872-ae2a-41cc-b9d7-7feb84170d61', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', 7);
INSERT INTO public.activities VALUES ('75826b6e-e911-42f0-8276-fe4e356ad9ff', 'Секреты успеха', 1, '09:00:00', '3bc03d77-e018-4952-ac02-573713857e01', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '433ff0a2-d74c-4c53-af85-062481fd430b', '42c4e5cf-4346-4678-9e22-bd432517b839', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', 11);
INSERT INTO public.activities VALUES ('fb94dda4-032b-4b49-bb89-c8be25fedfb0', 'Способы поиска специалистов', 1, '10:45:00', 'ab21bd68-ccc2-47c0-bac4-4e2faa41dad5', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', 11);
INSERT INTO public.activities VALUES ('b4d7c3b4-6c7f-4e6e-83bc-5ea6549b3348', 'Что нужно пользователям?', 1, '12:30:00', '9f29e6cd-132d-4fcb-a73f-cacc4d780f3b', 'eb7588c2-233f-4977-87f8-062c379f6680', '433ff0a2-d74c-4c53-af85-062481fd430b', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '42c4e5cf-4346-4678-9e22-bd432517b839', 11);
INSERT INTO public.activities VALUES ('34447976-0b0f-47f5-8222-8d3bceb5271f', 'Осознанность личных целей', 1, '09:00:00', 'c9114df0-c17d-42d1-b390-cdda586ea4e4', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '433ff0a2-d74c-4c53-af85-062481fd430b', '42c4e5cf-4346-4678-9e22-bd432517b839', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 14);
INSERT INTO public.activities VALUES ('850a2ba1-caf9-4b98-8556-47457b19e124', 'Soft skills', 1, '10:45:00', '11bd2843-8da2-4897-9b12-6b527495579d', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '13145872-ae2a-41cc-b9d7-7feb84170d61', 14);
INSERT INTO public.activities VALUES ('c072a94d-276f-413b-a25d-68726d4ffee2', 'Развитие проактивности', 2, '12:30:00', '467c13d0-37bb-4e65-a4c2-64421bd30ea7', '433ff0a2-d74c-4c53-af85-062481fd430b', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '42c4e5cf-4346-4678-9e22-bd432517b839', NULL, 14);
INSERT INTO public.activities VALUES ('8659d192-b10c-457b-955b-df9431d2d1ba', 'Введение в IT-субкультуру', 1, '09:00:00', '6f14b209-ae8f-41e8-8922-0d7bca67b2b4', '433ff0a2-d74c-4c53-af85-062481fd430b', '42c4e5cf-4346-4678-9e22-bd432517b839', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', 16);
INSERT INTO public.activities VALUES ('653f7a01-dbe4-4fc5-acf6-8fbf4067cfd9', 'Основы ООП', 1, '10:45:00', '5f71c4ce-afa7-44be-bb4d-0e3dc08cf159', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', 16);
INSERT INTO public.activities VALUES ('f0a2c26d-d573-4f15-be51-3cf9c8ae153d', 'Что нужно знать начинающему спецалисту', 1, '16:00:00', '50589cda-d271-4c5e-8c52-6cc718026724', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', 'eb7588c2-233f-4977-87f8-062c379f6680', '433ff0a2-d74c-4c53-af85-062481fd430b', '42c4e5cf-4346-4678-9e22-bd432517b839', 16);
INSERT INTO public.activities VALUES ('b1052d54-6d96-4043-8b00-7c44d0b46dd3', 'Идельный результат', 1, '09:00:00', '0e1938fe-b370-46cf-aa10-250646a3c26a', '42c4e5cf-4346-4678-9e22-bd432517b839', '433ff0a2-d74c-4c53-af85-062481fd430b', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 19);
INSERT INTO public.activities VALUES ('a7037e26-a9f7-42b2-8f23-fbc9a94226ce', 'Тайны и секреты', 2, '10:45:00', 'e9b939f6-37fd-46d9-9540-21632bea1c29', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', '13145872-ae2a-41cc-b9d7-7feb84170d61', '13145872-ae2a-41cc-b9d7-7feb84170d61', 19);
INSERT INTO public.activities VALUES ('dd7003f5-5cc5-44ca-92ca-27c347324219', 'Какрой язык программирования выбрать?', 2, '12:30:00', 'be6432fe-e82f-4c7b-8dbf-007335539578', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '13145872-ae2a-41cc-b9d7-7feb84170d61', '42c4e5cf-4346-4678-9e22-bd432517b839', 'eb7588c2-233f-4977-87f8-062c379f6680', NULL, 19);
INSERT INTO public.activities VALUES ('aa3bd754-8b75-4265-bb8e-d6c0172cb574', 'Войти в ТОП', 1, '09:00:00', 'c9e4d29f-8b56-4c90-99ed-2e3adb836dbc', '433ff0a2-d74c-4c53-af85-062481fd430b', '42c4e5cf-4346-4678-9e22-bd432517b839', '74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 20);
INSERT INTO public.activities VALUES ('4b6818e8-deec-4c29-a396-4260b4d49581', 'Секреты продвижения', 1, '10:45:00', 'e8e5659f-604f-44e8-8ede-b5b1a44dfeb9', '6e5f9870-01fd-430f-af9a-0d11d1c3d72a', '0d8466c5-80d1-4a70-8b25-89615f21fb62', '8d3fdad2-370a-48bb-b9a0-a6118ba96758', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '13145872-ae2a-41cc-b9d7-7feb84170d61', 20);
INSERT INTO public.activities VALUES ('64f64cb2-56c9-410e-b16c-e94ddcd617fa', 'Руководство проектами', 2, '12:30:00', '451b5292-87e2-4d79-826f-abab508269db', '13145872-ae2a-41cc-b9d7-7feb84170d61', 'b44e0b2c-4e16-4fd7-a271-fdbe06809880', '42c4e5cf-4346-4678-9e22-bd432517b839', '433ff0a2-d74c-4c53-af85-062481fd430b', 'eb7588c2-233f-4977-87f8-062c379f6680', 20);


--
-- TOC entry 5001 (class 0 OID 16452)
-- Dependencies: 222
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1, 'Абаза', 'image1.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (2, 'Абакан', 'image2.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (3, 'Абдулино', 'image3.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (4, 'Абинск', 'image4.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (5, 'Агидель', 'image5.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (6, 'Агрыз', 'image6.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (7, 'Адыгейск', 'image7.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (8, 'Азнакаево', 'image8.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (9, 'Азов', 'image9.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (10, 'Ак-Довурак', 'image10.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (11, 'Аксай', 'image11.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (12, 'Алагир', 'image12.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (13, 'Алапаевск', 'image13.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (14, 'Алатырь', 'image14.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (15, 'Алдан', 'image15.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (16, 'Алейск', 'image16.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (17, 'Александров', 'image17.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (18, 'Александровск', 'image18.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (19, 'Александровск-Сахалинский', 'image19.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (20, 'Алексеевка', 'image20.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (21, 'Алексин', 'image21.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (22, 'Алзамай', 'image22.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (23, 'Алупка', 'image23.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (24, 'Алушта', 'image24.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (25, 'Альметьевск', 'image25.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (26, 'Амурск', 'image26.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (27, 'Анадырь', 'image27.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (28, 'Анапа', 'image28.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (29, 'Ангарск', 'image29.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (30, 'Андреаполь', 'image30.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (31, 'Анжеро-Судженск', 'image31.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (32, 'Анива', 'image32.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (33, 'Апатиты', 'image33.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (34, 'Апрелевка', 'image34.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (35, 'Апшеронск', 'image35.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (36, 'Арамиль', 'image36.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (37, 'Аргун', 'image37.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (38, 'Ардатов', 'image38.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (39, 'Ардон', 'image39.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (40, 'Арзамас', 'image40.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (41, 'Аркадак', 'image41.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (42, 'Армавир', 'image42.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (43, 'Армянск', 'image43.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (44, 'Арсеньев', 'image44.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (45, 'Арск', 'image45.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (46, 'Артём', 'image46.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (47, 'Артёмовск', 'image47.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (48, 'Артёмовский', 'image48.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (49, 'Архангельск', 'image49.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (50, 'Асбест', 'image50.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (51, 'Асино', 'image51.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (52, 'Астрахань', 'image52.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (53, 'Аткарск', 'image53.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (54, 'Ахтубинск', 'image54.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (55, 'Ачинск', 'image55.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (56, 'Аша', 'image56.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (57, 'Бабаево', 'image57.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (58, 'Бабушкин', 'image58.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (59, 'Бавлы', 'image59.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (60, 'Багратионовск', 'image60.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (61, 'Байкальск', 'image61.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (62, 'Баймак', 'image62.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (63, 'Бакал', 'image63.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (64, 'Баксан', 'image64.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (65, 'Балабаново', 'image65.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (66, 'Балаково', 'image66.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (67, 'Балахна', 'image67.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (68, 'Балашиха', 'image68.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (69, 'Балашов', 'image69.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (70, 'Балей', 'image70.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (71, 'Балтийск', 'image71.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (72, 'Барабинск', 'image72.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (73, 'Барнаул', 'image73.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (74, 'Барыш', 'image74.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (75, 'Батайск', 'image75.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (76, 'Бахчисарай', 'image76.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (77, 'Бежецк', 'image77.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (78, 'Белая Калитва', 'image78.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (79, 'Белая Холуница', 'image79.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (80, 'Белгород', 'image80.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (81, 'Белебей', 'image81.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (82, 'Белёв', 'image82.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (83, 'Белинский', 'image83.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (84, 'Белово', 'image84.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (85, 'Белогорск', 'image85.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (86, 'Белозерск', 'image87.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (87, 'Белокуриха', 'image88.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (88, 'Беломорск', 'image89.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (89, 'Белоозёрский', 'image90.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (90, 'Белорецк', 'image91.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (91, 'Белореченск', 'image92.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (92, 'Белоусово', 'image93.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (93, 'Белоярский', 'image94.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (94, 'Белый', 'image95.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (95, 'Бердск', 'image96.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (96, 'Березники', 'image97.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (97, 'Берёзовский', 'image98.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (98, 'Беслан', 'image100.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (99, 'Бийск', 'image101.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (100, 'Бикин', 'image102.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (101, 'Билибино', 'image103.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (102, 'Биробиджан', 'image104.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (103, 'Бирск', 'image105.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (104, 'Бирюсинск', 'image106.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (105, 'Бирюч', 'image107.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (106, 'Благовещенск', 'image108.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (107, 'Благодарный', 'image110.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (108, 'Бобров', 'image111.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (109, 'Богданович', 'image112.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (110, 'Богородицк', 'image113.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (111, 'Богородск', 'image114.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (112, 'Боготол', 'image115.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (113, 'Богучар', 'image116.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (114, 'Бодайбо', 'image117.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (115, 'Бокситогорск', 'image118.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (116, 'Болгар', 'image119.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (117, 'Бологое', 'image120.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (118, 'Болотное', 'image121.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (119, 'Болохово', 'image122.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (120, 'Болхов', 'image123.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (121, 'Большой Камень', 'image124.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (122, 'Бор', 'image125.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (123, 'Борзя', 'image126.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (124, 'Борисоглебск', 'image127.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (125, 'Боровичи', 'image128.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (126, 'Боровск', 'image129.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (127, 'Бородино', 'image130.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (128, 'Братск', 'image131.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (129, 'Бронницы', 'image132.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (130, 'Брянск', 'image133.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (131, 'Бугульма', 'image134.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (132, 'Бугуруслан', 'image135.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (133, 'Будённовск', 'image136.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (134, 'Бузулук', 'image137.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (135, 'Буинск', 'image138.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (136, 'Буй', 'image139.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (137, 'Буйнакск', 'image140.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (138, 'Бутурлиновка', 'image141.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (139, 'Валдай', 'image142.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (140, 'Валуйки', 'image143.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (141, 'Велиж', 'image144.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (142, 'Великие Луки', 'image145.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (143, 'Великий Новгород', 'image146.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (144, 'Великий Устюг', 'image147.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (145, 'Вельск', 'image148.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (146, 'Венёв', 'image149.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (147, 'Верещагино', 'image150.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (148, 'Верея', 'image151.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (149, 'Верхнеуральск', 'image152.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (150, 'Верхний Тагил', 'image153.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (151, 'Верхний Уфалей', 'image154.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (152, 'Верхняя Пышма', 'image155.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (153, 'Верхняя Салда', 'image156.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (154, 'Верхняя Тура', 'image157.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (155, 'Верхотурье', 'image158.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (156, 'Верхоянск', 'image159.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (157, 'Весьегонск', 'image160.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (158, 'Ветлуга', 'image161.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (159, 'Видное', 'image162.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (160, 'Вилюйск', 'image163.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (161, 'Вилючинск', 'image164.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (162, 'Вихоревка', 'image165.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (163, 'Вичуга', 'image166.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (164, 'Владивосток', 'image167.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (165, 'Владикавказ', 'image168.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (166, 'Владимир', 'image169.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (167, 'Волгоград', 'image170.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (168, 'Волгодонск', 'image171.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (169, 'Волгореченск', 'image172.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (170, 'Волжск', 'image173.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (171, 'Волжский', 'image174.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (172, 'Вологда', 'image175.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (173, 'Володарск', 'image176.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (174, 'Волоколамск', 'image177.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (175, 'Волосово', 'image178.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (176, 'Волхов', 'image179.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (177, 'Волчанск', 'image180.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (178, 'Вольск', 'image181.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (179, 'Воркута', 'image182.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (180, 'Воронеж', 'image183.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (181, 'Ворсма', 'image184.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (182, 'Воскресенск', 'image185.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (183, 'Воткинск', 'image186.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (184, 'Всеволожск', 'image187.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (185, 'Вуктыл', 'image188.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (186, 'Выборг', 'image189.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (187, 'Выкса', 'image190.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (188, 'Высоковск', 'image191.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (189, 'Высоцк', 'image192.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (190, 'Вытегра', 'image193.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (191, 'Вышний Волочёк', 'image194.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (192, 'Вяземский', 'image195.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (193, 'Вязники', 'image196.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (194, 'Вязьма', 'image197.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (195, 'Вятские Поляны', 'image198.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (196, 'Гаврилов Посад', 'image199.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (197, 'Гаврилов-Ям', 'image200.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (198, 'Гагарин', 'image201.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (199, 'Гаджиево', 'image202.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (200, 'Гай', 'image203.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (201, 'Галич', 'image204.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (202, 'Гатчина', 'image205.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (203, 'Гвардейск', 'image206.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (204, 'Гдов', 'image207.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (205, 'Геленджик', 'image208.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (206, 'Георгиевск', 'image209.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (207, 'Глазов', 'image210.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (208, 'Голицыно', 'image211.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (209, 'Горбатов', 'image212.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (210, 'Горно-Алтайск', 'image213.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (211, 'Горнозаводск', 'image214.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (212, 'Горняк', 'image215.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (213, 'Городец', 'image216.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (214, 'Городище', 'image217.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (215, 'Городовиковск', 'image218.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (216, 'Гороховец', 'image219.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (217, 'Горячий Ключ', 'image220.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (218, 'Грайворон', 'image221.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (219, 'Гремячинск', 'image222.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (220, 'Грозный', 'image223.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (221, 'Грязи', 'image224.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (222, 'Грязовец', 'image225.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (223, 'Губаха', 'image226.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (224, 'Губкин', 'image227.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (225, 'Губкинский', 'image228.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (226, 'Гудермес', 'image229.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (227, 'Гуково', 'image230.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (228, 'Гулькевичи', 'image231.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (229, 'Гурьевск', 'image232.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (230, 'Гусев', 'image234.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (231, 'Гусиноозёрск', 'image235.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (232, 'Гусь-Хрустальный', 'image236.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (233, 'Давлеканово', 'image237.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (234, 'Дагестанские Огни', 'image238.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (235, 'Далматово', 'image239.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (236, 'Дальнегорск', 'image240.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (237, 'Дальнереченск', 'image241.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (238, 'Данилов', 'image242.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (239, 'Данков', 'image243.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (240, 'Дегтярск', 'image244.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (241, 'Дедовск', 'image245.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (242, 'Демидов', 'image246.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (243, 'Дербент', 'image247.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (244, 'Десногорск', 'image248.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (245, 'Джанкой', 'image249.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (246, 'Дзержинск', 'image250.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (247, 'Дзержинский', 'image251.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (248, 'Дивногорск', 'image252.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (249, 'Дигора', 'image253.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (250, 'Димитровград', 'image254.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (251, 'Дмитриев', 'image255.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (252, 'Дмитров', 'image256.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (253, 'Дмитровск', 'image257.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (254, 'Дно', 'image258.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (255, 'Добрянка', 'image259.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (256, 'Долгопрудный', 'image260.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (257, 'Долинск', 'image261.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (258, 'Домодедово', 'image262.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (259, 'Донецк', 'image263.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (260, 'Донской', 'image264.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (261, 'Дорогобуж', 'image265.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (262, 'Дрезна', 'image266.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (263, 'Дубна', 'image267.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (264, 'Дубовка', 'image268.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (265, 'Дудинка', 'image269.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (266, 'Духовщина', 'image270.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (267, 'Дюртюли', 'image271.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (268, 'Дятьково', 'image272.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (269, 'Евпатория', 'image273.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (270, 'Егорьевск', 'image274.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (271, 'Ейск', 'image275.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (272, 'Екатеринбург', 'image276.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (273, 'Елабуга', 'image277.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (274, 'Елец', 'image278.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (275, 'Елизово', 'image279.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (276, 'Ельня', 'image280.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (277, 'Еманжелинск', 'image281.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (278, 'Емва', 'image282.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (279, 'Енисейск', 'image283.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (280, 'Ермолино', 'image284.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (281, 'Ершов', 'image285.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (282, 'Ессентуки', 'image286.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (283, 'Ефремов', 'image287.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (284, 'Железноводск', 'image288.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (285, 'Железногорск', 'image289.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (286, 'Железногорск-Илимский', 'image291.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (287, 'Жердевка', 'image292.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (288, 'Жигулёвск', 'image293.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (289, 'Жиздра', 'image294.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (290, 'Жирновск', 'image295.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (291, 'Жуков', 'image296.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (292, 'Жуковка', 'image297.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (293, 'Жуковский', 'image298.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (294, 'Завитинск', 'image299.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (295, 'Заводоуковск', 'image300.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (296, 'Заволжск', 'image301.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (297, 'Заволжье', 'image302.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (298, 'Задонск', 'image303.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (299, 'Заинск', 'image304.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (300, 'Закаменск', 'image305.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (301, 'Заозёрный', 'image306.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (302, 'Заозёрск', 'image307.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (303, 'Западная Двина', 'image308.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (304, 'Заполярный', 'image309.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (305, 'Зарайск', 'image310.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (306, 'Заречный', 'image311.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (307, 'Заринск', 'image313.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (308, 'Звенигово', 'image314.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (309, 'Звенигород', 'image315.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (310, 'Зверево', 'image316.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (311, 'Зеленогорск', 'image317.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (312, 'Зеленоградск', 'image318.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (313, 'Зеленодольск', 'image319.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (314, 'Зеленокумск', 'image320.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (315, 'Зерноград', 'image321.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (316, 'Зея', 'image322.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (317, 'Зима', 'image323.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (318, 'Златоуст', 'image324.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (319, 'Злынка', 'image325.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (320, 'Змеиногорск', 'image326.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (321, 'Знаменск', 'image327.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (322, 'Зубцов', 'image328.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (323, 'Зуевка', 'image329.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (324, 'Ивангород', 'image330.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (325, 'Иваново', 'image331.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (326, 'Ивантеевка', 'image332.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (327, 'Ивдель', 'image333.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (328, 'Игарка', 'image334.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (329, 'Ижевск', 'image335.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (330, 'Избербаш', 'image336.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (331, 'Изобильный', 'image337.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (332, 'Иланский', 'image338.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (333, 'Инза', 'image339.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (334, 'Иннополис', 'image340.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (335, 'Инсар', 'image341.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (336, 'Инта', 'image342.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (337, 'Ипатово', 'image343.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (338, 'Ирбит', 'image344.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (339, 'Иркутск', 'image345.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (340, 'Исилькуль', 'image346.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (341, 'Искитим', 'image347.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (342, 'Истра', 'image348.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (343, 'Ишим', 'image349.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (344, 'Ишимбай', 'image350.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (345, 'Йошкар-Ола', 'image351.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (346, 'Кадников', 'image352.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (347, 'Казань', 'image353.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (348, 'Калач', 'image354.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (349, 'Калач-на-Дону', 'image355.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (350, 'Калачинск', 'image356.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (351, 'Калининград', 'image357.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (352, 'Калининск', 'image358.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (353, 'Калтан', 'image359.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (354, 'Калуга', 'image360.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (355, 'Калязин', 'image361.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (356, 'Камбарка', 'image362.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (357, 'Каменка', 'image363.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (358, 'Каменногорск', 'image364.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (359, 'Каменск-Уральский', 'image365.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (360, 'Каменск-Шахтинский', 'image366.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (361, 'Камень-на-Оби', 'image367.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (362, 'Камешково', 'image368.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (363, 'Камызяк', 'image369.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (364, 'Камышин', 'image370.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (365, 'Камышлов', 'image371.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (366, 'Канаш', 'image372.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (367, 'Кандалакша', 'image373.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (368, 'Канск', 'image374.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (369, 'Карабаново', 'image375.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (370, 'Карабаш', 'image376.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (371, 'Карабулак', 'image377.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (372, 'Карасук', 'image378.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (373, 'Карачаевск', 'image379.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (374, 'Карачев', 'image380.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (375, 'Каргат', 'image381.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (376, 'Каргополь', 'image382.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (377, 'Карпинск', 'image383.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (378, 'Карталы', 'image384.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (379, 'Касимов', 'image385.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (380, 'Касли', 'image386.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (381, 'Каспийск', 'image387.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (382, 'Катав-Ивановск', 'image388.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (383, 'Катайск', 'image389.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (384, 'Качканар', 'image390.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (385, 'Кашин', 'image391.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (386, 'Кашира', 'image392.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (387, 'Кедровый', 'image393.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (388, 'Кемерово', 'image394.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (389, 'Кемь', 'image395.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (390, 'Керчь', 'image396.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (391, 'Кизел', 'image397.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (392, 'Кизилюрт', 'image398.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (393, 'Кизляр', 'image399.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (394, 'Кимовск', 'image400.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (395, 'Кимры', 'image401.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (396, 'Кингисепп', 'image402.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (397, 'Кинель', 'image403.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (398, 'Кинешма', 'image404.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (399, 'Киреевск', 'image405.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (400, 'Киренск', 'image406.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (401, 'Киржач', 'image407.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (402, 'Кириллов', 'image408.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (403, 'Кириши', 'image409.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (404, 'Киров', 'image410.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (405, 'Кировград', 'image412.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (406, 'Кирово-Чепецк', 'image413.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (407, 'Кировск', 'image414.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (408, 'Кирс', 'image416.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (409, 'Кирсанов', 'image417.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (410, 'Киселёвск', 'image418.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (411, 'Кисловодск', 'image419.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (412, 'Клин', 'image420.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (413, 'Клинцы', 'image421.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (414, 'Княгинино', 'image422.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (415, 'Ковдор', 'image423.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (416, 'Ковров', 'image424.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (417, 'Ковылкино', 'image425.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (418, 'Когалым', 'image426.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (419, 'Кодинск', 'image427.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (420, 'Козельск', 'image428.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (421, 'Козловка', 'image429.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (422, 'Козьмодемьянск', 'image430.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (423, 'Кола', 'image431.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (424, 'Кологрив', 'image432.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (425, 'Коломна', 'image433.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (426, 'Колпашево', 'image434.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (427, 'Кольчугино', 'image435.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (428, 'Коммунар', 'image436.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (429, 'Комсомольск', 'image437.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (430, 'Комсомольск-на-Амуре', 'image438.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (431, 'Конаково', 'image439.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (432, 'Кондопога', 'image440.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (433, 'Кондрово', 'image441.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (434, 'Константиновск', 'image442.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (435, 'Копейск', 'image443.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (436, 'Кораблино', 'image444.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (437, 'Кореновск', 'image445.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (438, 'Коркино', 'image446.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (439, 'Королёв', 'image447.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (440, 'Короча', 'image448.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (441, 'Корсаков', 'image449.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (442, 'Коряжма', 'image450.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (443, 'Костерёво', 'image451.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (444, 'Костомукша', 'image452.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (445, 'Кострома', 'image453.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (446, 'Котельники', 'image454.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (447, 'Котельниково', 'image455.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (448, 'Котельнич', 'image456.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (449, 'Котлас', 'image457.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (450, 'Котово', 'image458.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (451, 'Котовск', 'image459.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (452, 'Кохма', 'image460.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (453, 'Красавино', 'image461.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (454, 'Красноармейск', 'image462.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (455, 'Красновишерск', 'image464.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (456, 'Красногорск', 'image465.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (457, 'Краснодар', 'image466.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (458, 'Краснозаводск', 'image467.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (459, 'Краснознаменск', 'image468.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (460, 'Краснокаменск', 'image470.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (461, 'Краснокамск', 'image471.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (462, 'Красноперекопск', 'image472.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (463, 'Краснослободск', 'image473.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (464, 'Краснотурьинск', 'image475.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (465, 'Красноуральск', 'image476.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (466, 'Красноуфимск', 'image477.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (467, 'Красноярск', 'image478.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (468, 'Красный Кут', 'image479.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (469, 'Красный Сулин', 'image480.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (470, 'Красный Холм', 'image481.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (471, 'Кремёнки', 'image482.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (472, 'Кропоткин', 'image483.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (473, 'Крымск', 'image484.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (474, 'Кстово', 'image485.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (475, 'Кубинка', 'image486.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (476, 'Кувандык', 'image487.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (477, 'Кувшиново', 'image488.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (478, 'Кудрово', 'image489.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (479, 'Кудымкар', 'image490.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (480, 'Кузнецк', 'image491.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (481, 'Куйбышев', 'image492.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (482, 'Кукмор', 'image493.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (483, 'Кулебаки', 'image494.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (484, 'Кумертау', 'image495.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (485, 'Кунгур', 'image496.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (486, 'Купино', 'image497.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (487, 'Курган', 'image498.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (488, 'Курганинск', 'image499.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (489, 'Курильск', 'image500.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (490, 'Курлово', 'image501.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (491, 'Куровское', 'image502.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (492, 'Курск', 'image503.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (493, 'Куртамыш', 'image504.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (494, 'Курчалой', 'image505.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (495, 'Курчатов', 'image506.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (496, 'Куса', 'image507.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (497, 'Кушва', 'image508.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (498, 'Кызыл', 'image509.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (499, 'Кыштым', 'image510.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (500, 'Кяхта', 'image511.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (501, 'Лабинск', 'image512.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (502, 'Лабытнанги', 'image513.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (503, 'Лагань', 'image514.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (504, 'Ладушкин', 'image515.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (505, 'Лаишево', 'image516.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (506, 'Лакинск', 'image517.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (507, 'Лангепас', 'image518.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (508, 'Лахденпохья', 'image519.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (509, 'Лебедянь', 'image520.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (510, 'Лениногорск', 'image521.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (511, 'Ленинск', 'image522.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (512, 'Ленинск-Кузнецкий', 'image523.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (513, 'Ленск', 'image524.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (514, 'Лермонтов', 'image525.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (515, 'Лесной', 'image526.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (516, 'Лесозаводск', 'image527.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (517, 'Лесосибирск', 'image528.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (518, 'Ливны', 'image529.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (519, 'Ликино-Дулёво', 'image530.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (520, 'Липецк', 'image531.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (521, 'Липки', 'image532.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (522, 'Лиски', 'image533.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (523, 'Лихославль', 'image534.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (524, 'Лобня', 'image535.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (525, 'Лодейное Поле', 'image536.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (526, 'Лосино-Петровский', 'image537.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (527, 'Луга', 'image538.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (528, 'Луза', 'image539.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (529, 'Лукоянов', 'image540.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (530, 'Луховицы', 'image541.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (531, 'Лысково', 'image542.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (532, 'Лысьва', 'image543.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (533, 'Лыткарино', 'image544.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (534, 'Льгов', 'image545.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (535, 'Любань', 'image546.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (536, 'Люберцы', 'image547.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (537, 'Любим', 'image548.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (538, 'Людиново', 'image549.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (539, 'Лянтор', 'image550.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (540, 'Магадан', 'image551.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (541, 'Магас', 'image552.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (542, 'Магнитогорск', 'image553.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (543, 'Майкоп', 'image554.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (544, 'Майский', 'image555.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (545, 'Макаров', 'image556.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (546, 'Макарьев', 'image557.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (547, 'Макушино', 'image558.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (548, 'Малая Вишера', 'image559.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (549, 'Малгобек', 'image560.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (550, 'Малмыж', 'image561.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (551, 'Малоархангельск', 'image562.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (552, 'Малоярославец', 'image563.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (553, 'Мамадыш', 'image564.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (554, 'Мамоново', 'image565.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (555, 'Мантурово', 'image566.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (556, 'Мариинск', 'image567.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (557, 'Мариинский Посад', 'image568.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (558, 'Маркс', 'image569.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (559, 'Махачкала', 'image570.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (560, 'Мглин', 'image571.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (561, 'Мегион', 'image572.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (562, 'Медвежьегорск', 'image573.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (563, 'Медногорск', 'image574.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (564, 'Медынь', 'image575.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (565, 'Межгорье', 'image576.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (566, 'Междуреченск', 'image577.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (567, 'Мезень', 'image578.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (568, 'Меленки', 'image579.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (569, 'Мелеуз', 'image580.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (570, 'Менделеевск', 'image581.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (571, 'Мензелинск', 'image582.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (572, 'Мещовск', 'image583.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (573, 'Миасс', 'image584.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (574, 'Микунь', 'image585.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (575, 'Миллерово', 'image586.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (576, 'Минеральные Воды', 'image587.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (577, 'Минусинск', 'image588.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (578, 'Миньяр', 'image589.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (579, 'Мирный', 'image590.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (580, 'Михайлов', 'image592.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (581, 'Михайловка', 'image593.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (582, 'Михайловск', 'image594.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (583, 'Мичуринск', 'image596.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (584, 'Могоча', 'image597.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (585, 'Можайск', 'image598.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (586, 'Можга', 'image599.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (587, 'Моздок', 'image600.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (588, 'Мончегорск', 'image601.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (589, 'Морозовск', 'image602.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (590, 'Моршанск', 'image603.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (591, 'Мосальск', 'image604.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (592, 'Москва', 'image605.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (593, 'Муравленко', 'image606.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (594, 'Мураши', 'image607.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (595, 'Мурино', 'image608.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (596, 'Мурманск', 'image609.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (597, 'Муром', 'image610.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (598, 'Мценск', 'image611.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (599, 'Мыски', 'image612.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (600, 'Мытищи', 'image613.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (601, 'Мышкин', 'image614.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (602, 'Набережные Челны', 'image615.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (603, 'Навашино', 'image616.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (604, 'Наволоки', 'image617.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (605, 'Надым', 'image618.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (606, 'Назарово', 'image619.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (607, 'Назрань', 'image620.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (608, 'Называевск', 'image621.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (609, 'Нальчик', 'image622.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (610, 'Нариманов', 'image623.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (611, 'Наро-Фоминск', 'image624.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (612, 'Нарткала', 'image625.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (613, 'Нарьян-Мар', 'image626.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (614, 'Находка', 'image627.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (615, 'Невель', 'image628.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (616, 'Невельск', 'image629.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (617, 'Невинномысск', 'image630.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (618, 'Невьянск', 'image631.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (619, 'Нелидово', 'image632.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (620, 'Неман', 'image633.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (621, 'Нерехта', 'image634.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (622, 'Нерчинск', 'image635.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (623, 'Нерюнгри', 'image636.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (624, 'Нестеров', 'image637.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (625, 'Нефтегорск', 'image638.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (626, 'Нефтекамск', 'image639.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (627, 'Нефтекумск', 'image640.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (628, 'Нефтеюганск', 'image641.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (629, 'Нея', 'image642.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (630, 'Нижневартовск', 'image643.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (631, 'Нижнекамск', 'image644.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (632, 'Нижнеудинск', 'image645.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (633, 'Нижние Серги', 'image646.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (634, 'Нижний Ломов', 'image647.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (635, 'Нижний Новгород', 'image648.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (636, 'Нижний Тагил', 'image649.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (637, 'Нижняя Салда', 'image650.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (638, 'Нижняя Тура', 'image651.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (639, 'Николаевск', 'image652.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (640, 'Николаевск-на-Амуре', 'image653.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (641, 'Никольск', 'image654.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (642, 'Никольское', 'image656.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (643, 'Новая Ладога', 'image657.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (644, 'Новая Ляля', 'image658.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (645, 'Новоалександровск', 'image659.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (646, 'Новоалтайск', 'image660.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (647, 'Новоаннинский', 'image661.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (648, 'Нововоронеж', 'image662.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (649, 'Новодвинск', 'image663.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (650, 'Новозыбков', 'image664.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (651, 'Новокубанск', 'image665.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (652, 'Новокузнецк', 'image666.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (653, 'Новокуйбышевск', 'image667.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (654, 'Новомичуринск', 'image668.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (655, 'Новомосковск', 'image669.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (656, 'Новопавловск', 'image670.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (657, 'Новоржев', 'image671.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (658, 'Новороссийск', 'image672.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (659, 'Новосибирск', 'image673.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (660, 'Новосиль', 'image674.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (661, 'Новосокольники', 'image675.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (662, 'Новотроицк', 'image676.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (663, 'Новоузенск', 'image677.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (664, 'Новоульяновск', 'image678.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (665, 'Новоуральск', 'image679.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (666, 'Новохопёрск', 'image680.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (667, 'Новочебоксарск', 'image681.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (668, 'Новочеркасск', 'image682.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (669, 'Новошахтинск', 'image683.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (670, 'Новый Оскол', 'image684.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (671, 'Новый Уренгой', 'image685.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (672, 'Ногинск', 'image686.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (673, 'Нолинск', 'image687.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (674, 'Норильск', 'image688.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (675, 'Ноябрьск', 'image689.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (676, 'Нурлат', 'image690.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (677, 'Нытва', 'image691.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (678, 'Нюрба', 'image692.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (679, 'Нягань', 'image693.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (680, 'Нязепетровск', 'image694.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (681, 'Няндома', 'image695.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (682, 'Облучье', 'image696.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (683, 'Обнинск', 'image697.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (684, 'Обоянь', 'image698.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (685, 'Обь', 'image699.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (686, 'Одинцово', 'image700.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (687, 'Озёрск', 'image701.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (688, 'Озёры', 'image703.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (689, 'Октябрьск', 'image704.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (690, 'Октябрьский', 'image705.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (691, 'Окуловка', 'image706.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (692, 'Олёкминск', 'image707.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (693, 'Оленегорск', 'image708.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (694, 'Олонец', 'image709.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (695, 'Омск', 'image710.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (696, 'Омутнинск', 'image711.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (697, 'Онега', 'image712.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (698, 'Опочка', 'image713.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (699, 'Орёл', 'image714.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (700, 'Оренбург', 'image715.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (701, 'Орехово-Зуево', 'image716.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (702, 'Орлов', 'image717.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (703, 'Орск', 'image718.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (704, 'Оса', 'image719.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (705, 'Осинники', 'image720.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (706, 'Осташков', 'image721.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (707, 'Остров', 'image722.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (708, 'Островной', 'image723.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (709, 'Острогожск', 'image724.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (710, 'Отрадное', 'image725.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (711, 'Отрадный', 'image726.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (712, 'Оха', 'image727.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (713, 'Оханск', 'image728.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (714, 'Очёр', 'image729.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (715, 'Павлово', 'image730.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (716, 'Павловск', 'image731.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (717, 'Павловский Посад', 'image732.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (718, 'Палласовка', 'image733.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (719, 'Партизанск', 'image734.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (720, 'Певек', 'image735.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (721, 'Пенза', 'image736.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (722, 'Первомайск', 'image737.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (723, 'Первоуральск', 'image738.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (724, 'Перевоз', 'image739.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (725, 'Пересвет', 'image740.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (726, 'Переславль-Залесский', 'image741.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (727, 'Пермь', 'image742.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (728, 'Пестово', 'image743.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (729, 'Петров Вал', 'image744.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (730, 'Петровск', 'image745.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (731, 'Петровск-Забайкальский', 'image746.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (732, 'Петрозаводск', 'image747.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (733, 'Петропавловск-Камчатский', 'image748.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (734, 'Петухово', 'image749.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (735, 'Петушки', 'image750.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (736, 'Печора', 'image751.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (737, 'Печоры', 'image752.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (738, 'Пикалёво', 'image753.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (739, 'Пионерский', 'image754.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (740, 'Питкяранта', 'image755.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (741, 'Плавск', 'image756.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (742, 'Пласт', 'image757.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (743, 'Плёс', 'image758.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (744, 'Поворино', 'image759.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (745, 'Подольск', 'image760.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (746, 'Подпорожье', 'image761.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (747, 'Покачи', 'image762.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (748, 'Покров', 'image763.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (749, 'Покровск', 'image764.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (750, 'Полевской', 'image765.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (751, 'Полесск', 'image766.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (752, 'Полысаево', 'image767.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (753, 'Полярные Зори', 'image768.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (754, 'Полярный', 'image769.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (755, 'Поронайск', 'image770.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (756, 'Порхов', 'image771.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (757, 'Похвистнево', 'image772.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (758, 'Почеп', 'image773.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (759, 'Починок', 'image774.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (760, 'Пошехонье', 'image775.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (761, 'Правдинск', 'image776.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (762, 'Приволжск', 'image777.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (763, 'Приморск', 'image778.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (764, 'Приморско-Ахтарск', 'image780.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (765, 'Приозерск', 'image781.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (766, 'Прокопьевск', 'image782.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (767, 'Пролетарск', 'image783.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (768, 'Протвино', 'image784.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (769, 'Прохладный', 'image785.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (770, 'Псков', 'image786.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (771, 'Пугачёв', 'image787.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (772, 'Пудож', 'image788.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (773, 'Пустошка', 'image789.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (774, 'Пучеж', 'image790.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (775, 'Пушкино', 'image791.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (776, 'Пущино', 'image792.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (777, 'Пыталово', 'image793.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (778, 'Пыть-Ях', 'image794.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (779, 'Пятигорск', 'image795.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (780, 'Радужный', 'image796.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (781, 'Райчихинск', 'image798.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (782, 'Раменское', 'image799.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (783, 'Рассказово', 'image800.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (784, 'Ревда', 'image801.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (785, 'Реж', 'image802.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (786, 'Реутов', 'image803.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (787, 'Ржев', 'image804.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (788, 'Родники', 'image805.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (789, 'Рославль', 'image806.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (790, 'Россошь', 'image807.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (791, 'Ростов-на-Дону', 'image808.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (792, 'Ростов', 'image809.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (793, 'Рошаль', 'image810.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (794, 'Ртищево', 'image811.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (795, 'Рубцовск', 'image812.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (796, 'Рудня', 'image813.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (797, 'Руза', 'image814.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (798, 'Рузаевка', 'image815.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (799, 'Рыбинск', 'image816.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (800, 'Рыбное', 'image817.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (801, 'Рыльск', 'image818.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (802, 'Ряжск', 'image819.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (803, 'Рязань', 'image820.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (804, 'Саки', 'image821.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (805, 'Салават', 'image822.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (806, 'Салаир', 'image823.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (807, 'Салехард', 'image824.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (808, 'Сальск', 'image825.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (809, 'Самара', 'image826.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (810, 'Санкт-Петербург', 'image827.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (811, 'Саранск', 'image828.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (812, 'Сарапул', 'image829.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (813, 'Саратов', 'image830.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (814, 'Саров', 'image831.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (815, 'Сасово', 'image832.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (816, 'Сатка', 'image833.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (817, 'Сафоново', 'image834.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (818, 'Саяногорск', 'image835.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (819, 'Саянск', 'image836.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (820, 'Светлогорск', 'image837.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (821, 'Светлоград', 'image838.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (822, 'Светлый', 'image839.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (823, 'Светогорск', 'image840.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (824, 'Свирск', 'image841.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (825, 'Свободный', 'image842.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (826, 'Себеж', 'image843.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (827, 'Севастополь', 'image844.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (828, 'Северо-Курильск', 'image845.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (829, 'Северобайкальск', 'image846.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (830, 'Северодвинск', 'image847.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (831, 'Североморск', 'image848.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (832, 'Североуральск', 'image849.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (833, 'Северск', 'image850.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (834, 'Севск', 'image851.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (835, 'Сегежа', 'image852.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (836, 'Сельцо', 'image853.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (837, 'Семёнов', 'image854.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (838, 'Семикаракорск', 'image855.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (839, 'Семилуки', 'image856.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (840, 'Сенгилей', 'image857.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (841, 'Серафимович', 'image858.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (842, 'Сергач', 'image859.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (843, 'Сергиев Посад', 'image860.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (844, 'Сердобск', 'image861.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (845, 'Серов', 'image862.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (846, 'Серпухов', 'image863.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (847, 'Сертолово', 'image864.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (848, 'Сибай', 'image865.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (849, 'Сим', 'image866.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (850, 'Симферополь', 'image867.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (851, 'Сковородино', 'image868.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (852, 'Скопин', 'image869.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (853, 'Славгород', 'image870.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (854, 'Славск', 'image871.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (855, 'Славянск-на-Кубани', 'image872.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (856, 'Сланцы', 'image873.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (857, 'Слободской', 'image874.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (858, 'Слюдянка', 'image875.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (859, 'Смоленск', 'image876.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (860, 'Снежинск', 'image877.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (861, 'Снежногорск', 'image878.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (862, 'Собинка', 'image879.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (863, 'Советск', 'image880.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (864, 'Советская Гавань', 'image883.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (865, 'Советский', 'image884.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (866, 'Сокол', 'image885.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (867, 'Солигалич', 'image886.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (868, 'Соликамск', 'image887.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (869, 'Солнечногорск', 'image888.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (870, 'Соль-Илецк', 'image889.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (871, 'Сольвычегодск', 'image890.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (872, 'Сольцы', 'image891.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (873, 'Сорочинск', 'image892.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (874, 'Сорск', 'image893.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (875, 'Сортавала', 'image894.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (876, 'Сосенский', 'image895.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (877, 'Сосновка', 'image896.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (878, 'Сосновоборск', 'image897.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (879, 'Сосновый Бор', 'image898.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (880, 'Сосногорск', 'image899.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (881, 'Сочи', 'image900.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (882, 'Спас-Деменск', 'image901.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (883, 'Спас-Клепики', 'image902.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (884, 'Спасск', 'image903.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (885, 'Спасск-Дальний', 'image904.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (886, 'Спасск-Рязанский', 'image905.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (887, 'Среднеколымск', 'image906.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (888, 'Среднеуральск', 'image907.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (889, 'Сретенск', 'image908.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (890, 'Ставрополь', 'image909.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (891, 'Старая Купавна', 'image910.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (892, 'Старая Русса', 'image911.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (893, 'Старица', 'image912.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (894, 'Стародуб', 'image913.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (895, 'Старый Крым', 'image914.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (896, 'Старый Оскол', 'image915.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (897, 'Стерлитамак', 'image916.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (898, 'Стрежевой', 'image917.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (899, 'Строитель', 'image918.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (900, 'Струнино', 'image919.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (901, 'Ступино', 'image920.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (902, 'Суворов', 'image921.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (903, 'Судак', 'image922.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (904, 'Суджа', 'image923.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (905, 'Судогда', 'image924.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (906, 'Суздаль', 'image925.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (907, 'Сунжа', 'image926.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (908, 'Суоярви', 'image927.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (909, 'Сураж', 'image928.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (910, 'Сургут', 'image929.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (911, 'Суровикино', 'image930.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (912, 'Сурск', 'image931.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (913, 'Сусуман', 'image932.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (914, 'Сухиничи', 'image933.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (915, 'Сухой Лог', 'image934.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (916, 'Сызрань', 'image935.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (917, 'Сыктывкар', 'image936.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (918, 'Сысерть', 'image937.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (919, 'Сычёвка', 'image938.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (920, 'Сясьстрой', 'image939.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (921, 'Тавда', 'image940.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (922, 'Таганрог', 'image941.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (923, 'Тайга', 'image942.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (924, 'Тайшет', 'image943.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (925, 'Талдом', 'image944.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (926, 'Талица', 'image945.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (927, 'Тамбов', 'image946.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (928, 'Тара', 'image947.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (929, 'Тарко-Сале', 'image948.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (930, 'Таруса', 'image949.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (931, 'Татарск', 'image950.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (932, 'Таштагол', 'image951.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (933, 'Тверь', 'image952.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (934, 'Теберда', 'image953.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (935, 'Тейково', 'image954.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (936, 'Темников', 'image955.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (937, 'Темрюк', 'image956.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (938, 'Терек', 'image957.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (939, 'Тетюши', 'image958.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (940, 'Тимашёвск', 'image959.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (941, 'Тихвин', 'image960.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (942, 'Тихорецк', 'image961.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (943, 'Тобольск', 'image962.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (944, 'Тогучин', 'image963.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (945, 'Тольятти', 'image964.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (946, 'Томари', 'image965.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (947, 'Томмот', 'image966.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (948, 'Томск', 'image967.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (949, 'Топки', 'image968.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (950, 'Торжок', 'image969.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (951, 'Торопец', 'image970.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (952, 'Тосно', 'image971.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (953, 'Тотьма', 'image972.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (954, 'Трёхгорный', 'image973.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (955, 'Троицк', 'image974.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (956, 'Трубчевск', 'image975.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (957, 'Туапсе', 'image976.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (958, 'Туймазы', 'image977.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (959, 'Тула', 'image978.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (960, 'Тулун', 'image979.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (961, 'Туран', 'image980.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (962, 'Туринск', 'image981.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (963, 'Тутаев', 'image982.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (964, 'Тында', 'image983.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (965, 'Тырныауз', 'image984.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (966, 'Тюкалинск', 'image985.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (967, 'Тюмень', 'image986.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (968, 'Уварово', 'image987.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (969, 'Углегорск', 'image988.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (970, 'Углич', 'image989.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (971, 'Удачный', 'image990.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (972, 'Удомля', 'image991.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (973, 'Ужур', 'image992.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (974, 'Узловая', 'image993.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (975, 'Улан-Удэ', 'image994.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (976, 'Ульяновск', 'image995.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (977, 'Унеча', 'image996.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (978, 'Урай', 'image997.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (979, 'Урень', 'image998.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (980, 'Уржум', 'image999.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (981, 'Урус-Мартан', 'image1000.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (982, 'Урюпинск', 'image1001.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (983, 'Усинск', 'image1002.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (984, 'Усмань', 'image1003.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (985, 'Усолье-Сибирское', 'image1004.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (986, 'Усолье', 'image1005.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (987, 'Уссурийск', 'image1006.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (988, 'Усть-Джегута', 'image1007.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (989, 'Усть-Илимск', 'image1008.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (990, 'Усть-Катав', 'image1009.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (991, 'Усть-Кут', 'image1010.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (992, 'Усть-Лабинск', 'image1011.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (993, 'Устюжна', 'image1012.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (994, 'Уфа', 'image1013.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (995, 'Ухта', 'image1014.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (996, 'Учалы', 'image1015.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (997, 'Уяр', 'image1016.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (998, 'Фатеж', 'image1017.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (999, 'Феодосия', 'image1018.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1000, 'Фокино', 'image1019.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1001, 'Фролово', 'image1021.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1002, 'Фрязино', 'image1022.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1003, 'Фурманов', 'image1023.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1004, 'Хабаровск', 'image1024.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1005, 'Хадыженск', 'image1025.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1006, 'Ханты-Мансийск', 'image1026.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1007, 'Харабали', 'image1027.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1008, 'Харовск', 'image1028.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1009, 'Хасавюрт', 'image1029.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1010, 'Хвалынск', 'image1030.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1011, 'Хилок', 'image1031.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1012, 'Химки', 'image1032.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1013, 'Холм', 'image1033.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1014, 'Холмск', 'image1034.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1015, 'Хотьково', 'image1035.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1016, 'Цивильск', 'image1036.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1017, 'Цимлянск', 'image1037.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1018, 'Циолковский', 'image1038.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1019, 'Чадан', 'image1039.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1020, 'Чайковский', 'image1040.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1021, 'Чапаевск', 'image1041.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1022, 'Чаплыгин', 'image1042.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1023, 'Чебаркуль', 'image1043.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1024, 'Чебоксары', 'image1044.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1025, 'Чегем', 'image1045.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1026, 'Чекалин', 'image1046.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1027, 'Челябинск', 'image1047.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1028, 'Чердынь', 'image1048.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1029, 'Черемхово', 'image1049.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1030, 'Черепаново', 'image1050.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1031, 'Череповец', 'image1051.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1032, 'Черкесск', 'image1052.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1033, 'Чёрмоз', 'image1053.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1034, 'Черноголовка', 'image1054.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1035, 'Черногорск', 'image1055.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1036, 'Чернушка', 'image1056.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1037, 'Черняховск', 'image1057.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1038, 'Чехов', 'image1058.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1039, 'Чистополь', 'image1059.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1040, 'Чита', 'image1060.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1041, 'Чкаловск', 'image1061.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1042, 'Чудово', 'image1062.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1043, 'Чулым', 'image1063.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1044, 'Чусовой', 'image1064.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1045, 'Чухлома', 'image1065.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1046, 'Шагонар', 'image1066.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1047, 'Шадринск', 'image1067.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1048, 'Шали', 'image1068.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1049, 'Шарыпово', 'image1069.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1050, 'Шарья', 'image1070.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1051, 'Шатура', 'image1071.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1052, 'Шахты', 'image1072.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1053, 'Шахунья', 'image1073.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1054, 'Шацк', 'image1074.jpeg');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1055, 'Шебекино', 'image1075.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1056, 'Шелехов', 'image1076.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1057, 'Шенкурск', 'image1077.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1058, 'Шилка', 'image1078.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1059, 'Шимановск', 'image1079.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1060, 'Шиханы', 'image1080.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1061, 'Шлиссельбург', 'image1081.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1062, 'Шумерля', 'image1082.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1063, 'Шумиха', 'image1083.gif');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1064, 'Шуя', 'image1084.png');
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1065, 'Щёкино', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1066, 'Щёлкино', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1067, 'Щёлково', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1068, 'Щигры', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1069, 'Щучье', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1070, 'Электрогорск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1071, 'Электросталь', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1072, 'Электроугли', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1073, 'Элиста', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1074, 'Энгельс', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1075, 'Эртиль', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1076, 'Югорск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1077, 'Южа', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1078, 'Южно-Сахалинск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1079, 'Южно-Сухокумск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1080, 'Южноуральск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1081, 'Юрга', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1082, 'Юрьев-Польский', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1083, 'Юрьевец', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1084, 'Юрюзань', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1085, 'Юхнов', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1086, 'Ядрин', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1087, 'Якутск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1088, 'Ялта', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1089, 'Ялуторовск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1090, 'Янаул', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1091, 'Яранск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1092, 'Яровое', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1093, 'Ярославль', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1094, 'Ярцево', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1095, 'Ясногорск', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1096, 'Ясный', NULL);
INSERT INTO public.cities OVERRIDING SYSTEM VALUE VALUES (1097, 'Яхрома', NULL);


--
-- TOC entry 5003 (class 0 OID 16462)
-- Dependencies: 224
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (1, 'Абхазия', 'Abkhazia', 895, 'AB');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (2, 'Австралия', 'Australia', 36, 'AU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (3, 'Австрия', 'Austria', 40, 'AT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (4, 'Азербайджан', 'Azerbaijan', 31, 'AZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (5, 'Албания', 'Albania', 8, 'AL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (6, 'Алжир', 'Algeria', 12, 'DZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (7, 'Американское Самоа', 'American Samoa', 16, 'AS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (8, 'Ангилья', 'Anguilla', 660, 'AI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (9, 'Ангола', 'Angola', 24, 'AO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (10, 'Андорра', 'Andorra', 20, 'AD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (11, 'Антарктида', 'Antarctica', 10, 'AQ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (12, 'Антигуа и Барбуда', 'Antigua and Barbuda', 28, 'AG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (13, 'Аргентина', 'Argentina', 32, 'AR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (14, 'Армения', 'Armenia', 51, 'AM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (15, 'Аруба', 'Aruba', 533, 'AW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (16, 'Афганистан', 'Afghanistan', 4, 'AF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (17, 'Багамы', 'Bahamas', 44, 'BS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (18, 'Бангладеш', 'Bangladesh', 50, 'BD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (19, 'Барбадос', 'Barbados', 52, 'BB');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (20, 'Бахрейн', 'Bahrain', 48, 'BH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (21, 'Беларусь', 'Belarus', 112, 'BY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (22, 'Белиз', 'Belize', 84, 'BZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (23, 'Бельгия', 'Belgium', 56, 'BE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (24, 'Бенин', 'Benin', 204, 'BJ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (25, 'Бермуды', 'Bermuda', 60, 'BM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (26, 'Болгария', 'Bulgaria', 100, 'BG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (27, 'Боливия, Многонациональное Государство', 'Bolivia, plurinational state of', 68, 'BO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (28, 'Бонайре, Саба и Синт-Эстатиус', 'Bonaire, Sint Eustatius and Saba', 535, 'BQ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (29, 'Босния и Герцеговина', 'Bosnia and Herzegovina', 70, 'BA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (30, 'Ботсвана', 'Botswana', 72, 'BW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (31, 'Бразилия', 'Brazil', 76, 'BR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (32, 'Британская территория в Индийском океане', 'British Indian Ocean Territory', 86, 'IO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (33, 'Бруней-Даруссалам', 'Brunei Darussalam', 96, 'BN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (34, 'Буркина-Фасо', 'Burkina Faso', 854, 'BF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (35, 'Бурунди', 'Burundi', 108, 'BI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (36, 'Бутан', 'Bhutan', 64, 'BT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (37, 'Вануату', 'Vanuatu', 548, 'VU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (38, 'Венгрия', 'Hungary', 348, 'HU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (39, 'Венесуэла Боливарианская Республика', 'Venezuela', 862, 'VE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (40, 'Виргинские острова, Британские', 'Virgin Islands, British', 92, 'VG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (41, 'Виргинские острова, США', 'Virgin Islands, U.S.', 850, 'VI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (42, 'Вьетнам', 'Vietnam', 704, 'VN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (43, 'Габон', 'Gabon', 266, 'GA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (44, 'Гаити', 'Haiti', 332, 'HT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (45, 'Гайана', 'Guyana', 328, 'GY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (46, 'Гамбия', 'Gambia', 270, 'GM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (47, 'Гана', 'Ghana', 288, 'GH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (48, 'Гваделупа', 'Guadeloupe', 312, 'GP');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (49, 'Гватемала', 'Guatemala', 320, 'GT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (50, 'Гвинея', 'Guinea', 324, 'GN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (51, 'Гвинея-Бисау', 'Guinea-Bissau', 624, 'GW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (52, 'Германия', 'Germany', 276, 'DE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (53, 'Гернси', 'Guernsey', 831, 'GG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (54, 'Гибралтар', 'Gibraltar', 292, 'GI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (55, 'Гондурас', 'Honduras', 340, 'HN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (56, 'Гонконг', 'Hong Kong', 344, 'HK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (57, 'Гренада', 'Grenada', 308, 'GD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (58, 'Гренландия', 'Greenland', 304, 'GL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (59, 'Греция', 'Greece', 300, 'GR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (60, 'Грузия', 'Georgia', 268, 'GE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (61, 'Гуам', 'Guam', 316, 'GU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (62, 'Дания', 'Denmark', 208, 'DK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (63, 'Джерси', 'Jersey', 832, 'JE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (64, 'Джибути', 'Djibouti', 262, 'DJ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (65, 'Доминика', 'Dominica', 212, 'DM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (66, 'Доминиканская Республика', 'Dominican Republic', 214, 'DO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (67, 'Египет', 'Egypt', 818, 'EG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (68, 'Замбия', 'Zambia', 894, 'ZM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (69, 'Западная Сахара', 'Western Sahara', 732, 'EH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (70, 'Зимбабве', 'Zimbabwe', 716, 'ZW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (71, 'Израиль', 'Israel', 376, 'IL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (72, 'Индия', 'India', 356, 'IN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (73, 'Индонезия', 'Indonesia', 360, 'ID');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (74, 'Иордания', 'Jordan', 400, 'JO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (75, 'Ирак', 'Iraq', 368, 'IQ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (76, 'Иран, Исламская Республика', 'Iran, Islamic Republic of', 364, 'IR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (77, 'Ирландия', 'Ireland', 372, 'IE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (78, 'Исландия', 'Iceland', 352, 'IS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (79, 'Испания', 'Spain', 724, 'ES');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (80, 'Италия', 'Italy', 380, 'IT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (81, 'Йемен', 'Yemen', 887, 'YE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (82, 'Кабо-Верде', 'Cape Verde', 132, 'CV');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (83, 'Казахстан', 'Kazakhstan', 398, 'KZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (84, 'Камбоджа', 'Cambodia', 116, 'KH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (85, 'Камерун', 'Cameroon', 120, 'CM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (86, 'Канада', 'Canada', 124, 'CA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (87, 'Катар', 'Qatar', 634, 'QA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (88, 'Кения', 'Kenya', 404, 'KE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (89, 'Кипр', 'Cyprus', 196, 'CY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (90, 'Киргизия', 'Kyrgyzstan', 417, 'KG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (91, 'Кирибати', 'Kiribati', 296, 'KI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (92, 'Китай', 'China', 156, 'CN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (93, 'Кокосовые (Килинг) острова', 'Cocos (Keeling) Islands', 166, 'CC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (94, 'Колумбия', 'Colombia', 170, 'CO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (95, 'Коморы', 'Comoros', 174, 'KM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (96, 'Конго', 'Congo', 178, 'CG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (97, 'Конго, Демократическая Республика', 'Congo, Democratic Republic of the', 180, 'CD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (98, 'Корея, Народно-Демократическая Республика', 'Korea, Democratic People''s republic of', 408, 'KP');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (99, 'Корея, Республика', 'Korea, Republic of', 410, 'KR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (100, 'Коста-Рика', 'Costa Rica', 188, 'CR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (101, 'Кот д''Ивуар', 'Cote d''Ivoire', 384, 'CI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (102, 'Куба', 'Cuba', 192, 'CU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (103, 'Кувейт', 'Kuwait', 414, 'KW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (104, 'Кюрасао', 'Curaçao', 531, 'CW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (105, 'Лаос', 'Lao People''s Democratic Republic', 418, 'LA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (106, 'Латвия', 'Latvia', 428, 'LV');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (107, 'Лесото', 'Lesotho', 426, 'LS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (108, 'Ливан', 'Lebanon', 422, 'LB');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (109, 'Ливийская Арабская Джамахирия', 'Libyan Arab Jamahiriya', 434, 'LY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (110, 'Либерия', 'Liberia', 430, 'LR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (111, 'Лихтенштейн', 'Liechtenstein', 438, 'LI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (112, 'Литва', 'Lithuania', 440, 'LT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (113, 'Люксембург', 'Luxembourg', 442, 'LU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (114, 'Маврикий', 'Mauritius', 480, 'MU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (115, 'Мавритания', 'Mauritania', 478, 'MR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (116, 'Мадагаскар', 'Madagascar', 450, 'MG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (117, 'Майотта', 'Mayotte', 175, 'YT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (118, 'Макао', 'Macao', 446, 'MO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (119, 'Малави', 'Malawi', 454, 'MW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (120, 'Малайзия', 'Malaysia', 458, 'MY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (121, 'Мали', 'Mali', 466, 'ML');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (122, 'Малые Тихоокеанские отдаленные острова Соединенных Штатов', 'United States Minor Outlying Islands', 581, 'UM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (123, 'Мальдивы', 'Maldives', 462, 'MV');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (124, 'Мальта', 'Malta', 470, 'MT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (125, 'Марокко', 'Morocco', 504, 'MA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (126, 'Мартиника', 'Martinique', 474, 'MQ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (127, 'Маршалловы острова', 'Marshall Islands', 584, 'MH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (128, 'Мексика', 'Mexico', 484, 'MX');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (129, 'Микронезия, Федеративные Штаты', 'Micronesia, Federated States of', 583, 'FM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (130, 'Мозамбик', 'Mozambique', 508, 'MZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (131, 'Молдова, Республика', 'Moldova', 498, 'MD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (132, 'Монако', 'Monaco', 492, 'MC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (133, 'Монголия', 'Mongolia', 496, 'MN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (134, 'Монтсеррат', 'Montserrat', 500, 'MS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (135, 'Мьянма', 'Myanmar', 104, 'MM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (136, 'Намибия', 'Namibia', 516, 'NA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (137, 'Науру', 'Nauru', 520, 'NR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (138, 'Непал', 'Nepal', 524, 'NP');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (139, 'Нигер', 'Niger', 562, 'NE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (140, 'Нигерия', 'Nigeria', 566, 'NG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (141, 'Нидерланды', 'Netherlands', 528, 'NL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (142, 'Никарагуа', 'Nicaragua', 558, 'NI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (143, 'Ниуэ', 'Niue', 570, 'NU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (144, 'Новая Зеландия', 'New Zealand', 554, 'NZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (145, 'Новая Каледония', 'New Caledonia', 540, 'NC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (146, 'Норвегия', 'Norway', 578, 'NO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (147, 'Объединенные Арабские Эмираты', 'United Arab Emirates', 784, 'AE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (148, 'Оман', 'Oman', 512, 'OM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (149, 'Остров Буве', 'Bouvet Island', 74, 'BV');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (150, 'Остров Мэн', 'Isle of Man', 833, 'IM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (151, 'Остров Норфолк', 'Norfolk Island', 574, 'NF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (152, 'Остров Рождества', 'Christmas Island', 162, 'CX');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (153, 'Остров Херд и острова Макдональд', 'Heard Island and McDonald Islands', 334, 'HM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (154, 'Острова Кайман', 'Cayman Islands', 136, 'KY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (155, 'Острова Кука', 'Cook Islands', 184, 'CK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (156, 'Острова Теркс и Кайкос', 'Turks and Caicos Islands', 796, 'TC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (157, 'Пакистан', 'Pakistan', 586, 'PK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (158, 'Палау', 'Palau', 585, 'PW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (159, 'Палестинская территория, оккупированная', 'Palestinian Territory, Occupied', 275, 'PS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (160, 'Панама', 'Panama', 591, 'PA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (161, 'Папский Престол (Государство — город Ватикан)', 'Holy See (Vatican City State)', 336, 'VA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (162, 'Папуа-Новая Гвинея', 'Papua New Guinea', 598, 'PG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (163, 'Парагвай', 'Paraguay', 600, 'PY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (164, 'Перу', 'Peru', 604, 'PE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (165, 'Питкерн', 'Pitcairn', 612, 'PN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (166, 'Польша', 'Poland', 616, 'PL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (167, 'Португалия', 'Portugal', 620, 'PT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (168, 'Пуэрто-Рико', 'Puerto Rico', 630, 'PR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (169, 'Республика Македония', 'Macedonia, The Former Yugoslav Republic Of', 807, 'MK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (170, 'Реюньон', 'Reunion', 638, 'RE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (171, 'Россия', 'Russian Federation', 643, 'RU');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (172, 'Руанда', 'Rwanda', 646, 'RW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (173, 'Румыния', 'Romania', 642, 'RO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (174, 'Самоа', 'Samoa', 882, 'WS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (175, 'Сан-Марино', 'San Marino', 674, 'SM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (176, 'Сан-Томе и Принсипи', 'Sao Tome and Principe', 678, 'ST');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (177, 'Саудовская Аравия', 'Saudi Arabia', 682, 'SA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (178, 'Свазиленд', 'Swaziland', 748, 'SZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (179, 'Святая Елена, Остров вознесения, Тристан-да-Кунья', 'Saint Helena, Ascension And Tristan Da Cunha', 654, 'SH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (180, 'Северные Марианские острова', 'Northern Mariana Islands', 580, 'MP');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (181, 'Сен-Бартельми', 'Saint Barthélemy', 652, 'BL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (182, 'Сен-Мартен', 'Saint Martin (French Part)', 663, 'MF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (183, 'Сенегал', 'Senegal', 686, 'SN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (184, 'Сент-Винсент и Гренадины', 'Saint Vincent and the Grenadines', 670, 'VC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (185, 'Сент-Люсия', 'Saint Lucia', 662, 'LC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (186, 'Сент-Китс и Невис', 'Saint Kitts and Nevis', 659, 'KN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (187, 'Сент-Пьер и Микелон', 'Saint Pierre and Miquelon', 666, 'PM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (188, 'Сербия', 'Serbia', 688, 'RS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (189, 'Сейшелы', 'Seychelles', 690, 'SC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (190, 'Сингапур', 'Singapore', 702, 'SG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (191, 'Синт-Мартен', 'Sint Maarten', 534, 'SX');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (192, 'Сирийская Арабская Республика', 'Syrian Arab Republic', 760, 'SY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (193, 'Словакия', 'Slovakia', 703, 'SK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (194, 'Словения', 'Slovenia', 705, 'SI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (195, 'Соединенное Королевство', 'United Kingdom', 826, 'GB');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (196, 'Соединенные Штаты', 'United States', 840, 'US');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (197, 'Соломоновы острова', 'Solomon Islands', 90, 'SB');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (198, 'Сомали', 'Somalia', 706, 'SO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (199, 'Судан', 'Sudan', 729, 'SD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (200, 'Суринам', 'Suriname', 740, 'SR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (201, 'Сьерра-Леоне', 'Sierra Leone', 694, 'SL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (202, 'Таджикистан', 'Tajikistan', 762, 'TJ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (203, 'Таиланд', 'Thailand', 764, 'TH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (204, 'Тайвань (Китай)', 'Taiwan, Province of China', 158, 'TW');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (205, 'Танзания, Объединенная Республика', 'Tanzania, United Republic Of', 834, 'TZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (206, 'Тимор-Лесте', 'Timor-Leste', 626, 'TL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (207, 'Того', 'Togo', 768, 'TG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (208, 'Токелау', 'Tokelau', 772, 'TK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (209, 'Тонга', 'Tonga', 776, 'TO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (210, 'Тринидад и Тобаго', 'Trinidad and Tobago', 780, 'TT');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (211, 'Тувалу', 'Tuvalu', 798, 'TV');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (212, 'Тунис', 'Tunisia', 788, 'TN');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (213, 'Туркмения', 'Turkmenistan', 795, 'TM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (214, 'Турция', 'Turkey', 792, 'TR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (215, 'Уганда', 'Uganda', 800, 'UG');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (216, 'Узбекистан', 'Uzbekistan', 860, 'UZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (217, 'Украина', 'Ukraine', 804, 'UA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (218, 'Уоллис и Футуна', 'Wallis and Futuna', 876, 'WF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (219, 'Уругвай', 'Uruguay', 858, 'UY');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (220, 'Фарерские острова', 'Faroe Islands', 234, 'FO');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (221, 'Фиджи', 'Fiji', 242, 'FJ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (222, 'Филиппины', 'Philippines', 608, 'PH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (223, 'Финляндия', 'Finland', 246, 'FI');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (224, 'Фолклендские острова (Мальвинские)', 'Falkland Islands (Malvinas)', 238, 'FK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (225, 'Франция', 'France', 250, 'FR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (226, 'Французская Гвиана', 'French Guiana', 254, 'GF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (227, 'Французская Полинезия', 'French Polynesia', 258, 'PF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (228, 'Французские Южные территории', 'French Southern Territories', 260, 'TF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (229, 'Хорватия', 'Croatia', 191, 'HR');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (230, 'Центрально-Африканская Республика', 'Central African Republic', 140, 'CF');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (231, 'Чад', 'Chad', 148, 'TD');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (232, 'Черногория', 'Montenegro', 499, 'ME');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (233, 'Чешская Республика', 'Czech Republic', 203, 'CZ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (234, 'Чили', 'Chile', 152, 'CL');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (235, 'Швейцария', 'Switzerland', 756, 'CH');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (236, 'Швеция', 'Sweden', 752, 'SE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (237, 'Шпицберген и Ян Майен', 'Svalbard and Jan Mayen', 744, 'SJ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (238, 'Шри-Ланка', 'Sri Lanka', 144, 'LK');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (239, 'Эквадор', 'Ecuador', 218, 'EC');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (240, 'Экваториальная Гвинея', 'Equatorial Guinea', 226, 'GQ');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (241, 'Эландские острова', 'Åland Islands', 248, 'AX');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (242, 'Эль-Сальвадор', 'El Salvador', 222, 'SV');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (243, 'Эритрея', 'Eritrea', 232, 'ER');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (244, 'Эстония', 'Estonia', 233, 'EE');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (245, 'Эфиопия', 'Ethiopia', 231, 'ET');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (246, 'Южная Африка', 'South Africa', 710, 'ZA');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (247, 'Южная Джорджия и Южные Сандвичевы острова', 'South Georgia and the South Sandwich Islands', 239, 'GS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (248, 'Южная Осетия', 'South Ossetia', 896, 'OS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (249, 'Южный Судан', 'South Sudan', 728, 'SS');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (250, 'Ямайка', 'Jamaica', 388, 'JM');
INSERT INTO public.countries OVERRIDING SYSTEM VALUE VALUES (251, 'Япония', 'Japan', 392, 'JP');


--
-- TOC entry 5007 (class 0 OID 16488)
-- Dependencies: 228
-- Data for Name: directions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.directions OVERRIDING SYSTEM VALUE VALUES (1, 'ИТ');
INSERT INTO public.directions OVERRIDING SYSTEM VALUE VALUES (2, 'Биг Дата');
INSERT INTO public.directions OVERRIDING SYSTEM VALUE VALUES (3, 'Дизайн');
INSERT INTO public.directions OVERRIDING SYSTEM VALUE VALUES (4, 'Аналитика');
INSERT INTO public.directions OVERRIDING SYSTEM VALUE VALUES (5, 'Информационная безопасность');


--
-- TOC entry 5011 (class 0 OID 16528)
-- Dependencies: 232
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (1, 'Первая встреча клуба «Leader stories» ', '2022-03-15', 1, 34, '1.jpeg', '20ee901a-8621-459b-a0b5-1f20d5fa939b');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (2, 'Первый в России JAVABOOTCAMP ', '2022-10-25', 3, 56, '2.jpeg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (3, 'Встреча клуба Leader Stories «Зачем развивать сотрудников? Они же уйдут» ', '2023-04-18', 3, 6, '3.jpeg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (4, 'Первый IoT-Forum в Санкт-Петербурге ', '2023-05-30', 3, 8, '4.jpeg', '4ce12df5-3317-46b4-a8c2-0d758ce4bbaf');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (5, 'План проекта: практические советы, типичные ошибки ', '2023-07-11', 2, 9, '5.png', 'f1248316-55eb-4a64-a377-0d171c9b4976');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (6, 'Планирование проекта: что делать после того, как выяснили цель ', '2022-03-20', 1, 70, '6.jpg', '17f76943-17a5-4a39-8e12-0ae8535a6c3b');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (7, 'Поисковая оптимизация (SEO) ', '2022-08-10', 1, 90, '7.jpg', 'db37a7c1-3f00-47ac-9afd-19f647464de7');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (8, 'Поисковая оптимизация. SEO оптимизация ', '2022-08-15', 2, 80, '8.jpeg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (9, 'Поликом Про и InfoWatch: круглый стол по информационной безопасности в Санкт-Петербурге ', '2022-02-02', 2, 78, '9.jpg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (10, 'Получи «100500» лидов в первые 5 секунд ', '2023-09-02', 3, 78, '10.jpg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (11, 'Пользовательские требования ', '2023-08-08', 2, 67, '11.jpg', 'f7fc7f63-bb54-4ddb-8dad-c5bcfd21ac42');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (12, 'Постоянно доступен: Налаживаем омниканальную коммуникацию с клиентами ', '2023-10-29', 3, 56, '12.jpg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (13, 'Построение гиперконвергентной инфраструктуры и VDI-решения ', '2023-10-28', 3, 45, '13.jpg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (14, 'Практикум «Обогнать конкурентов: усиливаем продажи и создаем клиентский сервис» ', '2022-07-28', 2, 78, '14.png', 'e67bf83b-67c1-400d-9a2d-f5cce8f1eb3f');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (15, 'Практикум по Customer Development с экспертом ФРИИ: грамотные продажи за 4 часа ', '2022-06-03', 3, 67, '15.jpg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (16, 'Практический воркшоп по созданию договоренностей в Scrum-команде ', '2022-05-16', 1, 7, '16.jpg', '3217cb45-273f-4d99-ade9-9924a8722122');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (17, 'Практическое применение диаграммы потоков данных (DFD, Data Flow Diagram) ', '2023-11-27', 3, 8, '17.jpg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (18, 'Практическое применение диаграммы состояний (UML StateChart) ', '2022-06-17', 3, 9, '18.jpeg', NULL);
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (19, 'Презентационная сессия «TTD: технологии для жизни 2022» ', '2022-01-30', 2, 3, '19.jpg', 'ca86a7e3-c6b1-40a1-a30b-f95a41b1c201');
INSERT INTO public.events OVERRIDING SYSTEM VALUE VALUES (20, 'Презентация курса «Методы, технологии, инструменты обучения персонала в технических, продуктовых и IT-компаниях» ', '2023-10-01', 3, 5, '20.jpg', '9db3a353-d501-4819-a6e8-d6bd450f674d');


--
-- TOC entry 5005 (class 0 OID 16478)
-- Dependencies: 226
-- Data for Name: genders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.genders OVERRIDING SYSTEM VALUE VALUES (1, 'М');
INSERT INTO public.genders OVERRIDING SYSTEM VALUE VALUES (2, 'Ж');


--
-- TOC entry 5009 (class 0 OID 16498)
-- Dependencies: 230
-- Data for Name: moderator_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.moderator_events OVERRIDING SYSTEM VALUE VALUES (1, 'IT в бизнесе');
INSERT INTO public.moderator_events OVERRIDING SYSTEM VALUE VALUES (2, 'Разработка приложений');
INSERT INTO public.moderator_events OVERRIDING SYSTEM VALUE VALUES (3, 'IT-инфраструктура');
INSERT INTO public.moderator_events OVERRIDING SYSTEM VALUE VALUES (4, 'Стартапы');
INSERT INTO public.moderator_events OVERRIDING SYSTEM VALUE VALUES (5, 'Информационная безопасность');


--
-- TOC entry 4999 (class 0 OID 16415)
-- Dependencies: 220
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.persons VALUES ('20ee901a-8621-459b-a0b5-1f20d5fa939b', 'Корнилов', 'Владимир', 'Степанович', '1991-02-08', 68, '7(821)277-59-90', 'foto2.jpg', '92129dd2-b1e5-48be-8d17-ab425bef3c4c', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('a26316c1-7560-4818-a5d1-fb36cfd22bb5', 'Трофимов', 'Любомир', 'Русланович', '1980-02-11', 71, '7(821)611-43-32', 'foto3.jpg', '44636349-5a05-470f-a134-938764295aa1', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('4ce12df5-3317-46b4-a8c2-0d758ce4bbaf', 'Симонов', 'Остап', 'Федотович', '1989-01-14', 91, '7(821)779-78-75', 'foto4.jpg', 'db601ce1-30fb-486c-b887-5e2dbbf5cef7', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('f1248316-55eb-4a64-a377-0d171c9b4976', 'Фокин', 'Клемент', 'Игнатьевич', '1973-01-15', 18, '7(821)177-06-74', 'foto6.jpg', '7d41e701-518f-4fe8-b946-351e11fcae5c', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('91c9dcfa-be81-4ae5-b02c-dbebe46e87f1', 'Захаров', 'Аверкий', 'Альбертович', '1981-06-24', 80, '7(821)856-28-93', 'foto7.jpg', '6f28ddc6-162d-4376-b63d-70b8c8dc45d5', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('db37a7c1-3f00-47ac-9afd-19f647464de7', 'Ермаков', 'Клемент', 'Проклович', '1972-12-04', 66, '7(821)007-84-60', 'foto9.jpg', '945a45f6-7e9f-406a-9ea0-036ebfc7390e', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('e67bf83b-67c1-400d-9a2d-f5cce8f1eb3f', 'Лазарев', 'Марк', 'Юлианович', '1996-05-11', 87, '7(821)376-94-02', 'foto10.jpg', '42540d5c-335e-4450-a50b-6fb4d9c1e0a0', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('f7fc7f63-bb54-4ddb-8dad-c5bcfd21ac42', 'Петров', 'Геннадий', 'Даниилович', '1989-08-06', 45, '7(821)685-48-91', 'foto11.jpg', '39a7afec-f994-4636-9e95-1f17f2595252', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('1e5bd55d-1220-44d3-a354-63fe4873f28d', 'Субботин', 'Мартин', 'Пантелеймонович', '1989-04-26', 86, '7(821)149-13-09', 'foto12.jpg', '4b76b843-27f8-4b0b-941a-9b8aecf0a714', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('3d0b5d33-c65a-421c-a376-87458a1e5681', 'Рожков', 'Демьян', 'Эдуардович', '1995-11-09', 45, '7(821)162-52-21', 'foto13.jpg', '6de6ee72-2d75-4867-a675-2510b5b728cb', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('3217cb45-273f-4d99-ade9-9924a8722122', 'Емельянов', 'Анатолий', 'Авксентьевич', '1982-10-17', 93, '7(821)976-48-88', 'foto14.jpg', '8ca450e0-002f-4996-8880-c1583ca80075', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('978f7c13-7fbe-4dac-a946-3b7f7b86736f', 'Петухов', 'Алан', 'Пётрович', '1987-01-29', 44, '7(821)749-53-09', 'foto15.jpg', 'a75db997-c096-4700-a2b4-0c988025a4fb', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('290879a0-baca-41d1-9fc4-77b23b4bcea5', 'Александров', 'Варлаам', 'Робертович', '1999-05-18', 73, '7(821)137-45-80', 'foto17.jpg', '5485e2a1-4645-48a0-b2ba-58f1defb3e5d', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('9db3a353-d501-4819-a6e8-d6bd450f674d', 'Максимов', 'Егор', 'Дамирович', '1975-11-30', 81, '7(821)579-45-88', 'foto18.jpg', '85b96cf2-aaf5-41bc-b36d-15e9d44f6100', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('73362549-5c42-4e37-b76a-743e33d38a5f', 'Комиссаров', 'Антон', 'Протасьевич', '1996-11-15', 13, '7(821)277-58-70', 'foto19.jpg', '334977b8-f0e7-4ca1-972e-1d044fb8fb11', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('4e94f4fe-b185-4a33-bf20-8d1d41a8dcda', 'Мамонтов', 'Прохор', 'Созонович', '1975-12-30', 61, '7(821)760-71-19', 'foto20.jpg', 'd6629f5e-44b2-4e7a-8143-da68d1b6fd65', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('de4cdcfd-b190-4000-91c4-eb4616836d5e', 'Баранов', 'Венедикт', 'Ефимович', '1988-07-15', 22, '7(821)478-05-95', 'foto21.jpg', '79c295f6-5bb9-40a5-82fe-bed475f55add', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('07a4677b-dded-4cf7-9f1d-ecbefc0b60ea', 'Одинцов', 'Дмитрий', 'Лаврентьевич', '1978-03-02', 82, '7(186)808-50-25', 'foto31.jpg', 'a27d750b-b709-42dc-bdd9-ebda26c318c4', 1, 5, NULL);
INSERT INTO public.persons VALUES ('74fa9ccd-c0c7-4d87-ac29-59b22d5ad801', 'Белова', 'Инга', 'Прокловна', '1972-09-16', 43, '7(215)064-59-70', 'foto32.jpg', '5fb23cbe-9a11-40fc-b5f0-af1d36609cef', 2, 5, NULL);
INSERT INTO public.persons VALUES ('8d3fdad2-370a-48bb-b9a0-a6118ba96758', 'Соловьёва', 'Аюна', 'Станиславовна', '1950-02-21', 36, '7(810)322-94-05', 'foto33.jpg', '1d95646c-8939-4a2a-9cf2-dece778f2cae', 2, 2, NULL);
INSERT INTO public.persons VALUES ('42c4e5cf-4346-4678-9e22-bd432517b839', 'Зайцев', 'Иван', 'Артемович', '1950-07-20', 75, '7(963)659-08-16', 'foto34.jpg', 'd85201e2-c14f-4248-ace8-bf55fb162ea7', 1, 2, NULL);
INSERT INTO public.persons VALUES ('0d8466c5-80d1-4a70-8b25-89615f21fb62', 'Некрасова', 'Лаура', 'Богдановна', '1950-08-19', 89, '7(138)268-54-96', 'foto35.jpg', '8ffa95dc-c9e0-40e5-a592-3ab734b2df6f', 2, 1, NULL);
INSERT INTO public.persons VALUES ('b44e0b2c-4e16-4fd7-a271-fdbe06809880', 'Брагин', 'Осип', 'Владиславович', '1963-03-06', 24, '7(276)229-95-45', 'foto36.jpg', '26ea9d51-f4dd-436a-b034-1779fa582cf9', 1, 5, NULL);
INSERT INTO public.persons VALUES ('433ff0a2-d74c-4c53-af85-062481fd430b', 'Игнатьев', 'Мирослав', 'Тарасович', '1973-03-07', 64, '7(346)523-76-14', 'foto37.jpg', '283812d6-e274-41d1-a175-164b65725c78', 1, 5, NULL);
INSERT INTO public.persons VALUES ('6e5f9870-01fd-430f-af9a-0d11d1c3d72a', 'Матвеева', 'Вера', 'Митрофановна', '1952-09-11', 75, '7(742)194-06-10', 'foto38.jpg', 'fa5b06b6-51f6-4a8a-ad33-d50bae95de1a', 2, 3, NULL);
INSERT INTO public.persons VALUES ('13145872-ae2a-41cc-b9d7-7feb84170d61', 'Пестова', 'Ева', 'Альбертовна', '1980-09-24', 75, '7(089)418-02-33', 'foto39.jpg', 'ff7da1b9-935a-4aa7-a1dd-7e4a923f91e1', 2, 2, NULL);
INSERT INTO public.persons VALUES ('eb7588c2-233f-4977-87f8-062c379f6680', 'Фомичёв', 'Варлаам', 'Дмитрьевич', '1994-09-26', 8, '7(097)858-38-14', 'foto30.jpg', '89f73285-30ee-4244-8d58-f201b60cb5c8', 1, 3, NULL);
INSERT INTO public.persons VALUES ('f9320d2e-9973-4115-8857-0ff5c82de607', 'Скворцов', 'Михаил', 'Артёмович', '1989-01-05', 1, '7(329)246-20-13', 'foto41.jpg', '4a4d2f9f-0e79-43f7-ad4b-410807944d50', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('a4ea2893-945b-4552-9c01-df74260f4022', 'Романова', 'Анастасия', 'Тимофеевна', '1980-09-01', 87, '7(226)494-15-47', 'foto42.jpg', '939a452b-0bfb-4440-9413-dba04fec93c7', 2, NULL, NULL);
INSERT INTO public.persons VALUES ('96bea75d-25fe-4661-9b8f-b684eba16f78', 'Белкин', 'Дмитрий', 'Александрович', '1981-03-02', 10, '7(725)164-24-56', 'foto43.jpg', '6a3e6116-61e6-41f5-b144-cc852782fac4', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('581a2e5d-32ae-492d-8b11-610ac1472473', 'Лаврова', 'Анастасия', 'Маратовна', '1981-09-12', 63, '7(388)191-50-31', 'foto44.jpg', '344daae4-514a-4578-a4b7-fb429e188018', 2, NULL, NULL);
INSERT INTO public.persons VALUES ('1ac5bf47-f980-48e6-b66b-62e4554339af', 'Громова', 'Виктория', 'Матвеевна', '1983-07-14', 69, '7(581)960-76-73', 'foto45.jpg', 'a6fcba5a-753f-4f17-85fc-b5c577bae5a5', 2, NULL, NULL);
INSERT INTO public.persons VALUES ('51e0f245-0b5c-41e9-a4bd-d5cb666d2f81', 'Карпов', 'Алексей', 'Артёмович', '1980-08-06', 78, '7(959)240-88-47', 'foto46.jpg', 'fd08a38d-d2e5-4a74-993a-c8bb83f15e70', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('a49ee5ea-d1da-469a-b888-b2cdeefa2d34', 'Прохоров', 'Максим', 'Серафимович', '1995-11-10', 59, '7(466)705-98-66', 'foto47.jpg', 'd31b43bc-b4e5-4942-b7c8-292510c3258f', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('4e890d68-666f-48a0-a2e6-d748dee98d79', 'Мешков', 'Даниил', 'Николаевич', '1984-11-20', 28, '7(640)704-75-62', 'foto48.jpg', '68cbfae0-135d-423a-9f25-e141db870d82', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('6bc928a6-b35f-4ca2-9d7c-8dea863e2a65', 'Рябова', 'Алиса', 'Викторовна', '1989-01-14', 57, '7(500)841-51-43', 'foto49.jpg', '09e2f12d-48fc-4338-b017-0141cf9589b3', 2, NULL, NULL);
INSERT INTO public.persons VALUES ('6ba7dc25-0d1b-4593-aa82-1757b7029dc7', 'Соловьев', 'Демид', 'Артёмович', '1981-12-21', 63, '7(053)696-95-19', 'foto40.jpg', 'bad733d7-43df-4906-a2df-7d67024892ac', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('644e58d7-2dc4-4e10-9cac-034b96e26068', 'Покровский', 'Роман', 'Дмитриевич', '1974-01-22', 73, '7(416)870-22-00', 'foto59.jpg', '70f3a253-bdb5-4643-97c4-fc812160c9a6', 1, 1, 1);
INSERT INTO public.persons VALUES ('6f14b209-ae8f-41e8-8922-0d7bca67b2b4', 'Чернышев', 'Ярослав', 'Андреевич', '1957-06-12', 47, '7(278)138-47-92', 'foto50.jpg', '9468fce3-2e49-4ed7-87a3-0fe615342263', 1, 1, 1);
INSERT INTO public.persons VALUES ('5f71c4ce-afa7-44be-bb4d-0e3dc08cf159', 'Суворова', 'Ева', 'Алексеевна', '1960-05-29', 21, '7(093)787-84-57', 'foto58.jpg', 'a9a66498-11b1-4e1a-9e72-68f5a7b70ed0', 2, 2, 2);
INSERT INTO public.persons VALUES ('50589cda-d271-4c5e-8c52-6cc718026724', 'Лосева', 'Аделина', 'Георгиевна', '1996-08-11', 96, '7(699)704-90-18', 'foto51.jpg', 'e9481bf4-d074-46f9-be40-b9dfb41ab765', 2, 3, 3);
INSERT INTO public.persons VALUES ('3d8b4f3e-d657-4acc-b04a-b54c10a837a5', 'Покровский', 'Марк', 'Максимович', '1968-09-23', 79, '7(312)920-22-96', 'foto52.jpg', '84da940d-4510-4ad7-b030-25e4a7f090e2', 1, 2, 2);
INSERT INTO public.persons VALUES ('7b8fe21f-ca92-4647-bcd1-fc9416f1e943', 'Акимова', 'София', 'Александровна', '1989-01-20', 72, '7(714)693-32-92', 'foto53.jpg', '6d7c952f-6e96-4a41-8765-2fbeb486c4b1', 2, 4, 4);
INSERT INTO public.persons VALUES ('855d68c9-1569-403c-b521-9613006b67b5', 'Майоров', 'Александр', 'Михайлович', '1998-05-01', 63, '7(605)246-65-83', 'foto54.jpg', 'bd09c7e8-89b7-4240-81a6-9d5320383580', 1, 1, 1);
INSERT INTO public.persons VALUES ('0e1938fe-b370-46cf-aa10-250646a3c26a', 'Прохорова', 'Анна', 'Фёдоровна', '1982-05-24', 72, '7(037)333-08-17', 'foto56.jpg', '2cc0ba35-b239-43a4-9a0f-a33b68121ce0', 2, 5, 5);
INSERT INTO public.persons VALUES ('e9b939f6-37fd-46d9-9540-21632bea1c29', 'Соловьев', 'Иван', 'Дмитриевич', '1969-03-28', 64, '7(594)615-77-80', 'foto57.jpg', 'f1e25837-c09f-42fb-b384-ddaf5f531c92', 1, 2, 2);
INSERT INTO public.persons VALUES ('be6432fe-e82f-4c7b-8dbf-007335539578', 'Лебедева', 'Виктория', 'Марковна', '1980-10-30', 48, '7(596)301-43-97', 'foto78.jpg', 'fcd0e7c9-b408-4eb7-9e3f-ba3ddb2133b6', 2, 4, 4);
INSERT INTO public.persons VALUES ('ca86a7e3-c6b1-40a1-a30b-f95a41b1c201', 'Бобров', 'Марк', 'Юрьевич', '1993-12-08', 20, '7(821)496-70-50', 'foto16.jpg', '34be7717-6f65-41cd-8968-1d5d6264b778', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('17f76943-17a5-4a39-8e12-0ae8535a6c3b', 'Егоров', 'Афанасий', 'Тарасович', '1977-06-26', 45, '7(821)623-59-80', 'foto8.jpg', '86bec09d-5dc1-4f71-8ee1-8b242ffad2b8', 1, NULL, NULL);
INSERT INTO public.persons VALUES ('ea482ffe-6b3f-48cc-a7de-27c95a24a10f', 'Шишкина', 'Светлана', 'Александровна', '1998-02-08', 46, '7(181)588-68-39', 'foto79.jpg', '2536ff10-106b-47fb-8be3-7d27ac1ea9cb', 2, 4, 4);
INSERT INTO public.persons VALUES ('c9e4d29f-8b56-4c90-99ed-2e3adb836dbc', 'Юдина', 'Татьяна', 'Максимовна', '1978-01-27', 76, '7(442)333-89-12', 'foto60.jpg', 'cb565bf5-abb0-4eb7-ac0f-c327c43b2ce6', 2, 5, 5);
INSERT INTO public.persons VALUES ('e8e5659f-604f-44e8-8ede-b5b1a44dfeb9', 'Рябинин', 'Григорий', 'Матвеевич', '1953-05-31', 24, '7(377)251-56-96', 'foto61.jpg', 'd641469e-982e-47a1-ab6c-69ddd786772e', 1, 3, 3);
INSERT INTO public.persons VALUES ('451b5292-87e2-4d79-826f-abab508269db', 'Тарасова', 'Валерия', 'Егоровна', '1975-12-24', 79, '7(575)142-09-75', 'foto62.jpg', 'deabff2f-b9fa-47be-886f-c479f6661e5f', 2, 3, 3);
INSERT INTO public.persons VALUES ('9447c00e-8628-47b8-8514-051cc644b6ea', 'Алексеев', 'Михаил', 'Глебович', '1976-05-12', 6, '7(979)385-40-57', 'foto63.jpg', 'f7a064e7-3046-42bc-856d-c22579cf2e15', 1, 3, 3);
INSERT INTO public.persons VALUES ('3bc03d77-e018-4952-ac02-573713857e01', 'Иванова', 'Виктория', 'Павловна', '1973-05-09', 72, '7(901)002-16-80', 'foto64.jpg', 'db8adda3-ab3d-4b77-9e36-a41ce258caf9', 2, 5, 5);
INSERT INTO public.persons VALUES ('ab21bd68-ccc2-47c0-bac4-4e2faa41dad5', 'Богданова', 'Олеся', 'Евгеньевна', '1962-08-26', 98, '7(272)350-20-30', 'foto65.jpg', '78fbfbc3-9bb8-479f-ac11-dc8b2054ca3c', 2, 5, 5);
INSERT INTO public.persons VALUES ('9f29e6cd-132d-4fcb-a73f-cacc4d780f3b', 'Иванов', 'Фёдор', 'Тимофеевич', '1988-11-23', 39, '7(812)026-33-34', 'foto66.jpg', '9f86233a-0899-4794-86b6-9a6b4bfc9358', 1, 2, 2);
INSERT INTO public.persons VALUES ('c9114df0-c17d-42d1-b390-cdda586ea4e4', 'Кузнецов', 'Семён', 'Владиславович', '1962-05-05', 13, '7(550)677-95-09', 'foto67.jpg', '628ca1ba-5d69-4af9-8871-8007920972d2', 1, 4, 4);
INSERT INTO public.persons VALUES ('11bd2843-8da2-4897-9b12-6b527495579d', 'Шульгина', 'Елизавета', 'Денисовна', '1989-01-13', 20, '7(596)221-45-84', 'foto68.jpg', '9eca2c15-2fb5-4a69-92ff-de7b57233864', 2, 5, 5);
INSERT INTO public.persons VALUES ('467c13d0-37bb-4e65-a4c2-64421bd30ea7', 'Петрова', 'Василиса', 'Георгиевна', '1987-04-25', 7, '7(588)448-48-41', 'foto69.jpg', '2fa4bdf2-5be6-46d1-b3ee-853589dece0a', 2, 2, 2);
INSERT INTO public.persons VALUES ('6662d561-fb24-4b89-bacb-262c2d482ad5', 'Захаров', 'Арнольд', 'Германнович', '1994-07-30', 81, '7(821)819-98-39', 'foto5.jpg', 'b3efca0d-98ff-49b9-a262-41b01b8401d2', 1, NULL, NULL);


--
-- TOC entry 4998 (class 0 OID 16400)
-- Dependencies: 219
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (1, 'Участник');
INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (2, 'Жюри');
INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (3, 'Организатор');
INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (4, 'Модератор');


--
-- TOC entry 4996 (class 0 OID 16389)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('92129dd2-b1e5-48be-8d17-ab425bef3c4c', '4sqplurb5eki@gmail.com', 'nOEBrK', 1);
INSERT INTO public.users VALUES ('44636349-5a05-470f-a134-938764295aa1', 'm73dobuzn6jc@gmail.com', 'TImO7k', 1);
INSERT INTO public.users VALUES ('db601ce1-30fb-486c-b887-5e2dbbf5cef7', '9mtkjdsrhp2c@yahoo.com', 'PtwSEA', 1);
INSERT INTO public.users VALUES ('b3efca0d-98ff-49b9-a262-41b01b8401d2', 'wxey0gmcjuz2@mail.com', 'EzwyiP', 1);
INSERT INTO public.users VALUES ('7d41e701-518f-4fe8-b946-351e11fcae5c', 'lqih53fw9ryx@tutanota.com', 'pEVpH3', 1);
INSERT INTO public.users VALUES ('6f28ddc6-162d-4376-b63d-70b8c8dc45d5', 'p473g2jlcmhi@outlook.com', 'eEJ83V', 1);
INSERT INTO public.users VALUES ('86bec09d-5dc1-4f71-8ee1-8b242ffad2b8', 't1dg96ikvorc@tutanota.com', '0Utzck', 1);
INSERT INTO public.users VALUES ('945a45f6-7e9f-406a-9ea0-036ebfc7390e', 'ah91upwo7xfl@mail.com', 'HLAFQB', 1);
INSERT INTO public.users VALUES ('42540d5c-335e-4450-a50b-6fb4d9c1e0a0', 'fskhuw2oxgev@outlook.com', 'nrBfHG', 1);
INSERT INTO public.users VALUES ('39a7afec-f994-4636-9e95-1f17f2595252', '6opkrq9n87d1@outlook.com', 'xM5QB5', 1);
INSERT INTO public.users VALUES ('4b76b843-27f8-4b0b-941a-9b8aecf0a714', 'epflsy9iobdx@tutanota.com', 'v5MxkG', 1);
INSERT INTO public.users VALUES ('6de6ee72-2d75-4867-a675-2510b5b728cb', 'zy8tom2bxnuk@mail.com', '8MkKg6', 1);
INSERT INTO public.users VALUES ('8ca450e0-002f-4996-8880-c1583ca80075', 'kd64ino5fcx3@outlook.com', 'COZkSO', 1);
INSERT INTO public.users VALUES ('a75db997-c096-4700-a2b4-0c988025a4fb', 'i4ex5whc7dqk@gmail.com', 'GYlXDR', 1);
INSERT INTO public.users VALUES ('34be7717-6f65-41cd-8968-1d5d6264b778', 'qsnyrwodje0k@outlook.com', '10PHSE', 1);
INSERT INTO public.users VALUES ('5485e2a1-4645-48a0-b2ba-58f1defb3e5d', 'tacixb04vh5g@gmail.com', 'uNRgsg', 1);
INSERT INTO public.users VALUES ('85b96cf2-aaf5-41bc-b36d-15e9d44f6100', '96o7iwszty5n@tutanota.com', '9YNtvb', 1);
INSERT INTO public.users VALUES ('334977b8-f0e7-4ca1-972e-1d044fb8fb11', 'yn6pfe4kasbo@outlook.com', '4rSPmK', 1);
INSERT INTO public.users VALUES ('d6629f5e-44b2-4e7a-8143-da68d1b6fd65', 'vny26gsmxu9k@tutanota.com', 'STSVII', 1);
INSERT INTO public.users VALUES ('79c295f6-5bb9-40a5-82fe-bed475f55add', 'mwlny4zqtc65@outlook.com', 'DsEhqN', 1);
INSERT INTO public.users VALUES ('a27d750b-b709-42dc-bdd9-ebda26c318c4', 'oconnell.steve@feest.com', 'ugWkzE', 2);
INSERT INTO public.users VALUES ('5fb23cbe-9a11-40fc-b5f0-af1d36609cef', 'olson.shanny@gmail.com', 'TsCX7X', 2);
INSERT INTO public.users VALUES ('1d95646c-8939-4a2a-9cf2-dece778f2cae', 'whirthe@beer.info', 'R2buBG', 2);
INSERT INTO public.users VALUES ('d85201e2-c14f-4248-ace8-bf55fb162ea7', 'rerdman@gmail.com', '6Kuk9B', 2);
INSERT INTO public.users VALUES ('8ffa95dc-c9e0-40e5-a592-3ab734b2df6f', 'pkutch@hotmail.com', 'XQZbTX', 2);
INSERT INTO public.users VALUES ('26ea9d51-f4dd-436a-b034-1779fa582cf9', 'trace.lindgren@beahan.com', 'AA6JS6', 2);
INSERT INTO public.users VALUES ('283812d6-e274-41d1-a175-164b65725c78', 'jadon85@gmail.com', 'j7WWL5', 2);
INSERT INTO public.users VALUES ('fa5b06b6-51f6-4a8a-ad33-d50bae95de1a', 'mathilde77@yahoo.com', '2QCbSj', 2);
INSERT INTO public.users VALUES ('ff7da1b9-935a-4aa7-a1dd-7e4a923f91e1', 'graham.robb@boyer.com', 'kFwax6', 2);
INSERT INTO public.users VALUES ('89f73285-30ee-4244-8d58-f201b60cb5c8', 'cleveland.hamill@gmail.com', 'SqJHTL', 2);
INSERT INTO public.users VALUES ('4a4d2f9f-0e79-43f7-ad4b-410807944d50', '3swfq0n756y1@mail.com', 'JyP2M2ji63', 3);
INSERT INTO public.users VALUES ('939a452b-0bfb-4440-9413-dba04fec93c7', 'wukm6dacf7v0@gmail.com', '8fb3RJT8c6', 3);
INSERT INTO public.users VALUES ('6a3e6116-61e6-41f5-b144-cc852782fac4', '5ku2w7nqzvot@gmail.com', '2T2xCYef86', 3);
INSERT INTO public.users VALUES ('344daae4-514a-4578-a4b7-fb429e188018', '8s54jayek2mt@outlook.com', 'nG7xGVi892', 3);
INSERT INTO public.users VALUES ('a6fcba5a-753f-4f17-85fc-b5c577bae5a5', 'dlm7wocnzhtp@mail.com', 'Ka74TC2r7m', 3);
INSERT INTO public.users VALUES ('fd08a38d-d2e5-4a74-993a-c8bb83f15e70', 'ekibvrcm71a6@gmail.com', 'fk9BHN2g96', 3);
INSERT INTO public.users VALUES ('d31b43bc-b4e5-4942-b7c8-292510c3258f', '70rkvgtfjswm@gmail.com', '9nM7A9Mtv5', 3);
INSERT INTO public.users VALUES ('68cbfae0-135d-423a-9f25-e141db870d82', 'vy3ajxkge8p7@mail.com', 'd6UAu83Sd8', 3);
INSERT INTO public.users VALUES ('09e2f12d-48fc-4338-b017-0141cf9589b3', 'tkgduj6na1hm@gmail.com', 'JS4K8pr54u', 3);
INSERT INTO public.users VALUES ('bad733d7-43df-4906-a2df-7d67024892ac', 'uw846cn27x9k@outlook.com', '42xF46LVkh', 3);
INSERT INTO public.users VALUES ('70f3a253-bdb5-4643-97c4-fc812160c9a6', 'i8brhz2gyx4j@gmail.com', '4VUmGj4t36', 4);
INSERT INTO public.users VALUES ('9468fce3-2e49-4ed7-87a3-0fe615342263', 'dic8qah9zbot@mail.com', 'b9zAs99XD3', 4);
INSERT INTO public.users VALUES ('a9a66498-11b1-4e1a-9e72-68f5a7b70ed0', 'o3gmly907wcn@mail.com', 'n6cx69AM4T', 4);
INSERT INTO public.users VALUES ('e9481bf4-d074-46f9-be40-b9dfb41ab765', 'qz901omryb7j@mail.com', 'P8c83u5fUR', 4);
INSERT INTO public.users VALUES ('84da940d-4510-4ad7-b030-25e4a7f090e2', 'm93nsaih4kl8@yahoo.com', 'f7S5zxH58B', 4);
INSERT INTO public.users VALUES ('6d7c952f-6e96-4a41-8765-2fbeb486c4b1', 'qgb9ea8wnl50@mail.com', 'c2vGi532VN', 4);
INSERT INTO public.users VALUES ('bd09c7e8-89b7-4240-81a6-9d5320383580', 'rzsj6wqd42vt@yahoo.com', '8jZ5LL2a2n', 4);
INSERT INTO public.users VALUES ('2cc0ba35-b239-43a4-9a0f-a33b68121ce0', 'wg9h3ixavl25@tutanota.com', 'D44jjR45gH', 4);
INSERT INTO public.users VALUES ('f1e25837-c09f-42fb-b384-ddaf5f531c92', '2nib6c5vl18k@outlook.com', '2c73vxTLP9', 4);
INSERT INTO public.users VALUES ('fcd0e7c9-b408-4eb7-9e3f-ba3ddb2133b6', 'wbs3znh5uxfr@tutanota.com', '69S6fMzeM2', 4);
INSERT INTO public.users VALUES ('2536ff10-106b-47fb-8be3-7d27ac1ea9cb', 'yl9hxt5dzajv@tutanota.com', 'j7TMm92s9X', 4);
INSERT INTO public.users VALUES ('cb565bf5-abb0-4eb7-ac0f-c327c43b2ce6', '4rqfa385p9gz@mail.com', 'XU5b8N42th', 4);
INSERT INTO public.users VALUES ('d641469e-982e-47a1-ab6c-69ddd786772e', 'ox7k5w6l04mi@gmail.com', '6R82k4nFnX', 4);
INSERT INTO public.users VALUES ('deabff2f-b9fa-47be-886f-c479f6661e5f', 'a8071jvd2m6z@tutanota.com', 'eC445cE8Yd', 4);
INSERT INTO public.users VALUES ('f7a064e7-3046-42bc-856d-c22579cf2e15', 'qxel0og2ps4t@gmail.com', '8T69Vef8Er', 4);
INSERT INTO public.users VALUES ('db8adda3-ab3d-4b77-9e36-a41ce258caf9', 'ixut6e0cnd84@gmail.com', '34nYAv56Cs', 4);
INSERT INTO public.users VALUES ('78fbfbc3-9bb8-479f-ac11-dc8b2054ca3c', 'es06joah3pfu@gmail.com', 'ru6x7PT2V4', 4);
INSERT INTO public.users VALUES ('9f86233a-0899-4794-86b6-9a6b4bfc9358', '0kmd26jfi859@mail.com', 'a7pXZ78a2J', 4);
INSERT INTO public.users VALUES ('628ca1ba-5d69-4af9-8871-8007920972d2', 'mn7bawsorg51@outlook.com', '8uTv4L8Cg4', 4);
INSERT INTO public.users VALUES ('9eca2c15-2fb5-4a69-92ff-de7b57233864', '1os2bmtpg6nv@mail.com', '6VM3r9jmS5', 4);
INSERT INTO public.users VALUES ('2fa4bdf2-5be6-46d1-b3ee-853589dece0a', 'vbpjslo28w6d@mail.com', 'c6m4L2ZD9j', 4);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 221
-- Name: cities_id_city_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_city_seq', 1097, true);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 223
-- Name: countries_id_country_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_country_seq', 251, true);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 227
-- Name: directions_id_direction_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directions_id_direction_seq', 5, true);


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 231
-- Name: events_id_event_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_event_seq', 20, true);


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 225
-- Name: genders_id_gender_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genders_id_gender_seq', 2, true);


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 229
-- Name: moderator_events_id_moderator_event_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moderator_events_id_moderator_event_seq', 5, true);


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 218
-- Name: roles_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_role_seq', 4, true);


--
-- TOC entry 4833 (class 2606 OID 16552)
-- Name: activities activities_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pk PRIMARY KEY (id_activity);


--
-- TOC entry 4805 (class 2606 OID 16458)
-- Name: cities cities_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pk PRIMARY KEY (id_city);


--
-- TOC entry 4807 (class 2606 OID 16460)
-- Name: cities cities_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_unique UNIQUE (city_name);


--
-- TOC entry 4809 (class 2606 OID 16468)
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (id_country);


--
-- TOC entry 4811 (class 2606 OID 16472)
-- Name: countries countries_unique_country_name_en; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_unique_country_name_en UNIQUE (country_name_en);


--
-- TOC entry 4813 (class 2606 OID 16470)
-- Name: countries countries_unique_country_name_ru; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_unique_country_name_ru UNIQUE (country_name_ru);


--
-- TOC entry 4815 (class 2606 OID 16476)
-- Name: countries countries_unique_letter_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_unique_letter_code UNIQUE (letter_code);


--
-- TOC entry 4817 (class 2606 OID 16474)
-- Name: countries countries_unique_numeric_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_unique_numeric_code UNIQUE (numeric_code);


--
-- TOC entry 4823 (class 2606 OID 16494)
-- Name: directions directions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directions
    ADD CONSTRAINT directions_pk PRIMARY KEY (id_direction);


--
-- TOC entry 4825 (class 2606 OID 16496)
-- Name: directions directions_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directions
    ADD CONSTRAINT directions_unique UNIQUE (direction_name);


--
-- TOC entry 4831 (class 2606 OID 16534)
-- Name: events events_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pk PRIMARY KEY (id_event);


--
-- TOC entry 4819 (class 2606 OID 16484)
-- Name: genders genders_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genders
    ADD CONSTRAINT genders_pk PRIMARY KEY (id_gender);


--
-- TOC entry 4821 (class 2606 OID 16486)
-- Name: genders genders_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genders
    ADD CONSTRAINT genders_unique UNIQUE (gender_name);


--
-- TOC entry 4827 (class 2606 OID 16504)
-- Name: moderator_events moderator_events_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderator_events
    ADD CONSTRAINT moderator_events_pk PRIMARY KEY (id_moderator_event);


--
-- TOC entry 4829 (class 2606 OID 16506)
-- Name: moderator_events moderator_events_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderator_events
    ADD CONSTRAINT moderator_events_unique UNIQUE (moderator_event_name);


--
-- TOC entry 4801 (class 2606 OID 16421)
-- Name: persons persons_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pk PRIMARY KEY (id_person);


--
-- TOC entry 4803 (class 2606 OID 16423)
-- Name: persons persons_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_unique UNIQUE (id_user);


--
-- TOC entry 4797 (class 2606 OID 16406)
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id_role);


--
-- TOC entry 4799 (class 2606 OID 16408)
-- Name: roles roles_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_unique UNIQUE (role_name);


--
-- TOC entry 4793 (class 2606 OID 16396)
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id_user);


--
-- TOC entry 4795 (class 2606 OID 16398)
-- Name: users users_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_unique UNIQUE (email);


--
-- TOC entry 4849 (class 2620 OID 16436)
-- Name: persons trg_check_id_direction; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_id_direction BEFORE INSERT OR UPDATE ON public.persons FOR EACH ROW EXECUTE FUNCTION public.check_id_direction();


--
-- TOC entry 4850 (class 2620 OID 16438)
-- Name: persons trg_check_id_moderator_event; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_id_moderator_event BEFORE INSERT OR UPDATE ON public.persons FOR EACH ROW EXECUTE FUNCTION public.check_id_moderator_event();


--
-- TOC entry 4842 (class 2606 OID 16584)
-- Name: activities activities_events_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_events_fk FOREIGN KEY (id_event) REFERENCES public.events(id_event) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4843 (class 2606 OID 16553)
-- Name: activities activities_persons_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_persons_fk FOREIGN KEY (id_moderator) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4844 (class 2606 OID 16559)
-- Name: activities activities_persons_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_persons_fk_1 FOREIGN KEY (id_jury_1) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4845 (class 2606 OID 16564)
-- Name: activities activities_persons_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_persons_fk_2 FOREIGN KEY (id_jury_2) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4846 (class 2606 OID 16569)
-- Name: activities activities_persons_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_persons_fk_3 FOREIGN KEY (id_jury_3) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4847 (class 2606 OID 16574)
-- Name: activities activities_persons_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_persons_fk_4 FOREIGN KEY (id_jury_4) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4848 (class 2606 OID 16579)
-- Name: activities activities_persons_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_persons_fk_5 FOREIGN KEY (id_jury_5) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4840 (class 2606 OID 16535)
-- Name: events events_cities_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_cities_fk FOREIGN KEY (id_city) REFERENCES public.cities(id_city) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4841 (class 2606 OID 16540)
-- Name: events events_persons_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_persons_fk FOREIGN KEY (id_winner) REFERENCES public.persons(id_person) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4835 (class 2606 OID 16512)
-- Name: persons persons_countries_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_countries_fk FOREIGN KEY (id_country) REFERENCES public.countries(id_country) ON UPDATE CASCADE;


--
-- TOC entry 4836 (class 2606 OID 16517)
-- Name: persons persons_directions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_directions_fk FOREIGN KEY (id_direction) REFERENCES public.directions(id_direction) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4837 (class 2606 OID 16507)
-- Name: persons persons_genders_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_genders_fk FOREIGN KEY (id_gender) REFERENCES public.genders(id_gender) ON UPDATE CASCADE;


--
-- TOC entry 4838 (class 2606 OID 16522)
-- Name: persons persons_moderator_events_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_moderator_events_fk FOREIGN KEY (id_moderator_event) REFERENCES public.moderator_events(id_moderator_event) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4839 (class 2606 OID 16424)
-- Name: persons persons_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_users_fk FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4834 (class 2606 OID 16410)
-- Name: users users_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_roles_fk FOREIGN KEY (id_role) REFERENCES public.roles(id_role) ON UPDATE CASCADE ON DELETE SET DEFAULT;


-- Completed on 2025-03-03 21:04:08

--
-- PostgreSQL database dump complete
--

