PGDMP  
    5                }            fleetManagementSystem    17.4    17.4 
    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    24576    fleetManagementSystem    DATABASE     �   CREATE DATABASE "fleetManagementSystem" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
 '   DROP DATABASE "fleetManagementSystem";
                     postgres    false            �            1255    32774    fetch_client_location()    FUNCTION     m  CREATE FUNCTION public.fetch_client_location() RETURNS TABLE(client_id character varying, latitude double precision, longitude double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        client_location.client_id,
       	client_location.latitude,
        client_location.longitude
    FROM 
        public.client_location;
END;
$$;
 .   DROP FUNCTION public.fetch_client_location();
       public               postgres    false            �            1255    24583    fetch_worker_location()    FUNCTION     m  CREATE FUNCTION public.fetch_worker_location() RETURNS TABLE(worker_id character varying, latitude double precision, longitude double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        worker_location.worker_id,
       	worker_location.latitude,
        worker_location.longitude
    FROM 
        public.worker_location;
END;
$$;
 .   DROP FUNCTION public.fetch_worker_location();
       public               postgres    false            �            1259    32768    client_location    TABLE     �   CREATE TABLE public.client_location (
    client_id character varying,
    latitude double precision,
    longitude double precision
);
 #   DROP TABLE public.client_location;
       public         heap r       postgres    false            �            1259    24578    worker_location    TABLE     �   CREATE TABLE public.worker_location (
    worker_id character varying,
    latitude double precision,
    longitude double precision
);
 #   DROP TABLE public.worker_location;
       public         heap r       postgres    false            �          0    32768    client_location 
   TABLE DATA           I   COPY public.client_location (client_id, latitude, longitude) FROM stdin;
    public               postgres    false    218   3       �          0    24578    worker_location 
   TABLE DATA           I   COPY public.worker_location (worker_id, latitude, longitude) FROM stdin;
    public               postgres    false    217   �       �   L   x�-ʱ�0D��c��K[��>V������V���j�puL�pr��{}P3�S�̘?�i�SB�."/K��      �   �   x�5�M�@�=����wq��bB�1,<���m��ͼa~O�)�$��bJJtB��9Z�[�u\�,`B����V�����i�̯q��m���XM���%�ǹ�V��y$2w�V�ED	�۴�kA!Mӏ���z��S�w�,�ѓP�Y�ߪUh3�`Tx.�CLW����!�k\m3S�r��AX     