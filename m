Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E87157E7E
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Apr 2024 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712692214; cv=none; b=CF2mARCxrJHuSxhBO7g82I5GmNo6kfElmDiG398NhZaBqYc54U7lfCwGb4MAtEJdJBmZANIwzVTmIF5SgZcE++PVFUc6DnIBv+yxosqe4r6YqxAGbi6zqOWAcUrPfq0kaqOZv3f7PylYsuEYcF/nm5Zhb66K4PZplpERkQ7Xnzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712692214; c=relaxed/simple;
	bh=zBG57+g6OWQxuIYisxSoawye0hcIgd/pRc/vgNjjsGo=;
	h=From:Message-Id:Content-Type:Mime-Version:Subject:Date:
	 In-Reply-To:Cc:To:References; b=q7UHFyzp+W9q2kGGqeY38cbmNlnvXl8xCxCMPkliPetVO1KXLnACzOH8K/AiLJn8WjYevkPrEDP0XylX+fA5HxJD5SdRSCkGNp3m97GB5u6pEe4hNiZbKXXVO3nV6wzC1okqBXTLo+R6npM+lUNBDJkpJkOsKssd9ErfFaIM5gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=EeHSRD7O; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="EeHSRD7O"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecee5c08e6so5602076b3a.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 Apr 2024 12:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1712692212; x=1713297012; darn=vger.kernel.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=wZyLNu08PDSjT6gyg1TWlhOYY4G4DIOkCASERAKTzG8=;
        b=EeHSRD7OD4d0oFOuUUBLbRaq2FLmhM6qeqMv3eoRnXPC6nIv3/CAFCNROFMPJimkqh
         YtbOMnCeJ6OuL5DX94Z1OaP8TLpL3xYSsoq9Z2ewxb8HpEILjifPruHz0n1teW9BYLLL
         nT/gmgOU7gsjSkVddlcu2/AAHFXCtbolpD3KtMevjq2/X8Rxcv0e8I/CCVYqbqgfJbXu
         PjMy3Csx0rZ9e41PB/Koo2xYIAB4DvXORn6VjmtCnYff78ZZoJUTwGSXazM1/0rnKehb
         UHSR6NsCi2NYCJZJSqaJ4kKnEuG5JXR70YXV+DnWqNnqgVkDQqwRiKnQhen72hCJcRd4
         DBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712692212; x=1713297012;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZyLNu08PDSjT6gyg1TWlhOYY4G4DIOkCASERAKTzG8=;
        b=RQm4q4ciGrfq13YUv2ISoslsUnRczqE0UQM4cIlXA0OY58W0+nlJU7Z+ffmyrKv60q
         rLlcD+54xVDnjKR0oSuTdmHc6qBUyRTXTaouoKFzwHwL7wtVAmbm2XE4I3+IVwUnEeXY
         bBVFeR//rPIRy9SE6dnQdb7tokzJOfgzFULEaM7St2bB7tPsY0W5ZOSJNTRpaBR1VG+t
         mF5gWR7pkdGUkE831b/15uVOD237gJ3i+AN3N5xWH79qPU4l9+OLTRqQHMBn6tVhgm4v
         N2qugeBFi+ozv4HcFSDgJL5Cmv8dr5uJ5YGDWv2v6pSEQwearaGGVq5O96JoNB6B4UgG
         Nhxw==
X-Forwarded-Encrypted: i=1; AJvYcCVQt0We0vKMKiDJ5jtTzBs1bzWR2bKWuC9UmqoSqzsqV5MZyFISpZPhiv92y7Aji0wVsIntB1AXeEsSkpkDfkXPzgqP16InME3yDVSZQ6c=
X-Gm-Message-State: AOJu0YzbR56GnBCemn3UP1hLxRTTnUyGG/17bU7f/5bV7Tp1tfhMHX+H
	lmYeziv7ADAz5g28pzc3ujGVWfyX2oZcJ55ShS10wPEhpE5UpOlLMhVaisTcHPk=
X-Google-Smtp-Source: AGHT+IH2BhIfNslbxdXrrtOrTtS1i/2Ol/r2Z2Qb1u5BZArDRPJcwyViq+GB++/e5kc6Hetz+zaaSA==
X-Received: by 2002:a05:6300:8086:b0:1a7:3365:d8ed with SMTP id ap6-20020a056300808600b001a73365d8edmr962787pzc.29.1712692211587;
        Tue, 09 Apr 2024 12:50:11 -0700 (PDT)
Received: from cabot.adilger.int (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id h21-20020a63c015000000b005b458aa0541sm8438545pgg.15.2024.04.09.12.50.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2024 12:50:11 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <32378212-7A10-4562-8670-3F0FB7126F9B@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_ECA1B460-583E-424F-86F4-A01D2C16C3A3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 01/13] fs: fiemap: add physical_length field to extents
Date: Tue, 9 Apr 2024 13:50:08 -0600
In-Reply-To: <20240409162232.GA6367@frogsfrogsfrogs>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Jonathan Corbet <corbet@lwn.net>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-bcachefs@vger.kernel.org,
 linux-btrfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org,
 kernel-team@meta.com
To: "Darrick J. Wong" <djwong@kernel.org>
References: <cover.1712126039.git.sweettea-kernel@dorminy.me>
 <1ba5bfccccbf4ff792f178268badde056797d0c4.1712126039.git.sweettea-kernel@dorminy.me>
 <20240409162232.GA6367@frogsfrogsfrogs>
X-Mailer: Apple Mail (2.3273)


--Apple-Mail=_ECA1B460-583E-424F-86F4-A01D2C16C3A3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 9, 2024, at 10:22 AM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Wed, Apr 03, 2024 at 03:22:42AM -0400, Sweet Tea Dorminy wrote:
>> Some filesystems support compressed extents which have a larger =
logical
>> size than physical, and for those filesystems, it can be useful for
>> userspace to know how much space those extents actually use. For
>> instance, the compsize [1] tool for btrfs currently uses =
btrfs-internal,
>> root-only ioctl to find the actual disk space used by a file; it =
would
>> be better and more useful for this information to require fewer
>> privileges and to be usable on more filesystems. Therefore, use one =
of
>> the padding u64s in the fiemap extent structure to return the actual
>> physical length; and, for now, return this as equal to the logical
>> length.
>>=20
>> [1] https://github.com/kilobyte/compsize
>>=20
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>> Documentation/filesystems/fiemap.rst | 28 +++++++++++++++++-------
>> fs/ioctl.c                           |  3 ++-
>> include/uapi/linux/fiemap.h          | 32 =
++++++++++++++++++++++------
>> 3 files changed, 47 insertions(+), 16 deletions(-)
>>=20
>> diff --git a/Documentation/filesystems/fiemap.rst =
b/Documentation/filesystems/fiemap.rst
>> index 93fc96f760aa..c2bfa107c8d7 100644
>> --- a/Documentation/filesystems/fiemap.rst
>> +++ b/Documentation/filesystems/fiemap.rst
>> @@ -80,14 +80,24 @@ Each extent is described by a single =
fiemap_extent structure as
>> returned in fm_extents::
>>=20
>>     struct fiemap_extent {
>> -	    __u64	fe_logical;  /* logical offset in bytes for the =
start of
>> -				* the extent */
>> -	    __u64	fe_physical; /* physical offset in bytes for the =
start
>> -				* of the extent */
>> -	    __u64	fe_length;   /* length in bytes for the extent =
*/
>> -	    __u64	fe_reserved64[2];
>> -	    __u32	fe_flags;    /* FIEMAP_EXTENT_* flags for this =
extent */
>> -	    __u32	fe_reserved[3];
>> +            /*
>> +             * logical offset in bytes for the start of
>> +             * the extent from the beginning of the file
>> +             */
>> +            __u64 fe_logical;
>> +            /*
>> +             * physical offset in bytes for the start
>> +             * of the extent from the beginning of the disk
>> +             */
>> +            __u64 fe_physical;
>> +            /* logical length in bytes for this extent */
>> +            __u64 fe_logical_length;
>> +            /* physical length in bytes for this extent */
>> +            __u64 fe_physical_length;
>> +            __u64 fe_reserved64[1];
>> +            /* FIEMAP_EXTENT_* flags for this extent */
>> +            __u32 fe_flags;
>> +            __u32 fe_reserved[3];
>>     };
>>=20
>> All offsets and lengths are in bytes and mirror those on disk.  It is =
valid
>> @@ -175,6 +185,8 @@ FIEMAP_EXTENT_MERGED
>>   userspace would be highly inefficient, the kernel will try to merge =
most
>>   adjacent blocks into 'extents'.
>>=20
>> +FIEMAP_EXTENT_HAS_PHYS_LEN
>> +  This will be set if the file system populated the physical length =
field.
>=20
> Just out of curiosity, should filesystems set this flag and
> fe_physical_length if fe_physical_length =3D=3D fe_logical_length?
> Or just leave both blank?

In the original thread, Dave thought it would be better to always set
fe_physical_length and the flag, so that userspace applications which do
not properly check the flag will not be confused/broken by differences =
in
filesystem behavior in the future when this is in use.

=
https://patchwork.ozlabs.org/project/linux-ext4/patch/4f8d5dc5b51a43efaf16=
c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz/

>=20
>> VFS -> File System Implementation
>> ---------------------------------
>> diff --git a/fs/ioctl.c b/fs/ioctl.c
>> index 661b46125669..8afd32e1a27a 100644
>> --- a/fs/ioctl.c
>> +++ b/fs/ioctl.c
>> @@ -138,7 +138,8 @@ int fiemap_fill_next_extent(struct =
fiemap_extent_info *fieinfo, u64 logical,
>> 	memset(&extent, 0, sizeof(extent));
>> 	extent.fe_logical =3D logical;
>> 	extent.fe_physical =3D phys;
>> -	extent.fe_length =3D len;
>> +	extent.fe_logical_length =3D len;
>> +	extent.fe_physical_length =3D len;
>> 	extent.fe_flags =3D flags;
>>=20
>> 	dest +=3D fieinfo->fi_extents_mapped;
>> diff --git a/include/uapi/linux/fiemap.h =
b/include/uapi/linux/fiemap.h
>> index 24ca0c00cae3..3079159b8e94 100644
>> --- a/include/uapi/linux/fiemap.h
>> +++ b/include/uapi/linux/fiemap.h
>> @@ -14,14 +14,30 @@
>>=20
>> #include <linux/types.h>
>>=20
>> +/*
>> + * For backward compatibility, where the member of the struct was =
called
>> + * fe_length instead of fe_logical_length.
>> + */
>> +#define fe_length fe_logical_length
>=20
> This #define has global scope; are you sure this isn't going to cause =
a
> weird build problem downstream with some program that declares an
> unrelated fe_length symbol?

I guess it's possible.  I'm not dead set on this part of the change.
I thought it was cleaner to separate the two in the struct, but I
can see the argument that a UAPI field struct should not change names.
It would be possible to have:

   #define fe_logical_length fe_length

which would have much less chance of namespace collisions I think.
New applications can start to use this for some years, before
making a permanent switch, but again not something I'm stuck on...

Cheers, Andreas

>> +
>> struct fiemap_extent {
>> -	__u64 fe_logical;  /* logical offset in bytes for the start of
>> -			    * the extent from the beginning of the file =
*/
>> -	__u64 fe_physical; /* physical offset in bytes for the start
>> -			    * of the extent from the beginning of the =
disk */
>> -	__u64 fe_length;   /* length in bytes for this extent */
>> -	__u64 fe_reserved64[2];
>> -	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
>> +	/*
>> +	 * logical offset in bytes for the start of
>> +	 * the extent from the beginning of the file
>> +	 */
>> +	__u64 fe_logical;
>> +	/*
>> +	 * physical offset in bytes for the start
>> +	 * of the extent from the beginning of the disk
>> +	 */
>> +	__u64 fe_physical;
>> +	/* logical length in bytes for this extent */
>> +	__u64 fe_logical_length;
>=20
> Or why not just leave the field name the same since the "logical =
length
> in bytes" comment is present both here in the header and again in the
> documentation?
>=20
> --D
>=20
>> +	/* physical length in bytes for this extent */
>> +	__u64 fe_physical_length;
>> +	__u64 fe_reserved64[1];
>> +	/* FIEMAP_EXTENT_* flags for this extent */
>> +	__u32 fe_flags;
>> 	__u32 fe_reserved[3];
>> };
>>=20
>> @@ -66,5 +82,7 @@ struct fiemap {
>> 						    * merged for =
efficiency. */
>> #define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with =
other
>> 						    * files. */
>> +#define FIEMAP_EXTENT_HAS_PHYS_LEN	0x00004000 /* Physical length is =
valid
>> +						    * and set by FS. */
>>=20
>> #endif /* _UAPI_LINUX_FIEMAP_H */
>> --
>> 2.43.0
>>=20
>>=20
>=20


Cheers, Andreas






--Apple-Mail=_ECA1B460-583E-424F-86F4-A01D2C16C3A3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmYVm/AACgkQcqXauRfM
H+CxqRAAu2r0TTDsoXra17ylZesykQhj4IRUya7tEvmLkYpkPw2xkXPWHYjE18n9
I9ZcaDWdTabEUTDMG6ljdzbyYNJUqscMo3QqX+r9juPamhs95sSX7ZSct4EmDsTg
4vy0dE1z/gSICqhnnHC2CK4YGGcjDCr3wd29HS1QakiLtVPKNTTAb95JSaOgrokn
PQp9fge1bF4J8sfIeSC4pxd8fqnNo79HK7v0knS5LN9R8UhdYu+vqIOIE7OJHKol
ivzNeaMzRUXlwDfv/xxF5tYaEJLty20oVRR1LEjDz/caaox9CtfSJ0WsObka4Bzp
Oo7epgfbyrqhJps8vUH0u344YRxhwdJFMM4eC5CU/CyZ9KV3THjYh4Eh+H5c8giB
vsAwd8qqk1VI7XtrlZuYdnyGwmmJQSPdDFiJbLukzJC332UWsOUXbgVZ7Boxcbsc
s5Mnd/jFmx1QEYIT6pgF0AXzsCVO21vyKJiVtVJFwWiNxvyyKxZ/f2PWHjUtUe7l
G134UbM3qYKg5xn/C6yt6/uH5QYdoqM2QLjv3AemnYejt6gmMYv+VREYfQenz27a
pkXV9d8dKxaL99pqIdYvl8K4z/EboYZkcHlC6F5oRtaFI7mvURapN+3n3KXfxmJT
Di2YKi7MZg1mpxYAbzLS5YIhrpMCx1BGg3j4GJYdZSAqdQFJZuw=
=bJQI
-----END PGP SIGNATURE-----

--Apple-Mail=_ECA1B460-583E-424F-86F4-A01D2C16C3A3--
