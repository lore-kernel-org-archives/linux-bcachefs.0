Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB21C174E;
	Fri, 31 Jan 2025 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738347179; cv=none; b=CDyUpd/Mj2Pe0dcFFqVU5oTZRTIMVGUUKkj6N1Ph4jrW+sd2etjKNxVFkP2I3gqpiyYkw7RkPpciM8oKk4CcDMO4KjDwqCQHraEaT2XE9lPgVfmrtpY7UJCJr9ycHLvRqso2llnvvsYvpOlycxz/jhJcSSiEhvODK+B4CATNSf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738347179; c=relaxed/simple;
	bh=hTfkhCSorZs3b2PtCt1LvffA30B8ElSrebOBChO7JQg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IOcxar9h2CD+d9UNzd8EX/HymMEGLM1+STbMugBpdEfp5cMePJBTzwRKfYWRrCcIy2+cAQUyeMpOSYwJD40ERuaESMkFfN2mlp/mN1EFc4XfY2kHQaEtVTlqsTcZW7mNjG3TkHdmJ/YG9y8eluiWtBh6TZ3dwTU/bW+klpCcwsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SfaB442t; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SfaB442t"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21636268e43so51702825ad.2;
        Fri, 31 Jan 2025 10:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738347177; x=1738951977; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5MzkVzIpaLC+Yjf9Sv5e9gOmWcmltNqG5MWfZ8w2J8=;
        b=SfaB442tHF5ZmRJWLfHMYe80dLOK89tZTXdfgZz4kDw5HQu845QOJK4NJtyUwK+hhd
         HYPF1yK74lTmZF5/JWN8GOGf3F4gXXfZDbihuSoUJfbZyg9C1op+SQBE3H3tPDJAL/zj
         FnYtUmgu6o3HtjMeFcDWYzCV9425+Ln2rD+0pcK8+BzmxKXWyFVo+MyxEQVAhsJI9Mr0
         bOju6T8/RbvKuQ7vfpPXoOePgqNJWFwxSaYtrp714zCdFKqZfh4AHGZsIMdagNMgq0gT
         sOnHvrmJFzlM7+Z3fqAyP5JWLpS0hR0mQYEcT/2/Cq/qHeS+DMZ4EJk5D1bUlXe23KFm
         Lb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738347177; x=1738951977;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z5MzkVzIpaLC+Yjf9Sv5e9gOmWcmltNqG5MWfZ8w2J8=;
        b=oS/gelYyBQIUSu2IvnnPBtjm4VEXvn5BT1sC0SPQQcQp32GFUqvdLTpIOJ+Xgi0sQm
         dY2QcuzET+6o2fHkjYCcT/JTMnnn+7TmO7/n5zSWtUixBkniplCsSgTiIJgGPzO9zY/Y
         naLV4Lxbin0qs+D9iva+NmOlaHBUUqsq9rOXSFKA5g/G+y002RTEEBPlZW7sxmp7WQ61
         SCz2SQSILq2kQWUEVn9ydcr+JD2pXcQtH3ZhA3YHW68+tJYjzX4bS5/qOmUhaX3yATG/
         4r3dNjENtev+vLmAqDkyL/LeYThSZmwmyNgXE9AE0hXptB5sjCnCGiIhg8+saJWr+0U3
         6Oag==
X-Forwarded-Encrypted: i=1; AJvYcCUgMr1kY3WokiIDUbWtL5UKLLfFFOhONGRg2HJ8pO7fdp6rFl5eGFb5uGdcyNVYhRCFX7g7txqtMVlH4VRnKQ==@vger.kernel.org, AJvYcCW1Em+I862VLzMgtXFUV4oM11DHWJpoz1h7x2XY9fAj68OZsn/hwwsYLRzUXbYAOIMVirLpU4b97ie14T6o@vger.kernel.org
X-Gm-Message-State: AOJu0YyHm5snrFoE8sKfJ+gWk5l19IIoHt9dIHTar0COVsdf/9TEb9bs
	j0dMqD+YJXSF1goexH+INIhfow6AE3vAX93vYJ1zY9g+J3vRH5h1
X-Gm-Gg: ASbGncsFiJ4ZagV6eMX6NNKhzIVveZNUw6DG1Rqzp7X+jPdThBr7Mi0Ed1n4uBiElk6
	RsaIecrg/kPjv37HCEbX+3rEL9uNu8g+Hzyqo6ZMOeCyLJhmI+gbGGjA2fcQeNQqeBQMEMN53WE
	9U4VR8YYsWAl7z5JwiUzWD6qOvsmKrtmZ+i2JcgDccU4UK51vWMiZtlL8B8qsXd5jsiEbz933cy
	cGU9/Jq9q4sz8EclrfwUPwmRUGKIINXIuvqwSGpi+ar1Te7QUoyADwocLFwFSM1FWLoeyr87GQ=
X-Google-Smtp-Source: AGHT+IElfKZw+KJ090MMfWu1M/fOPGzTMOpq8Iw/DAl94dv9qGFaRd4KZDJTGtu9oBDHMw/yOs75ZQ==
X-Received: by 2002:a17:902:d2c4:b0:216:2d42:2e05 with SMTP id d9443c01a7336-21dd7d72e78mr215904165ad.22.1738347177170;
        Fri, 31 Jan 2025 10:12:57 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de31f5f4esm33613965ad.69.2025.01.31.10.12.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jan 2025 10:12:56 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v2] bcachefs: fix deadlock in journal_entry_open()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250131124751.172123-1-aha310510@gmail.com>
Date: Sat, 1 Feb 2025 02:12:37 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D73FB067-2AC0-4175-AFF1-A9C1365EBBCD@gmail.com>
References: <20250131124751.172123-1-aha310510@gmail.com>
To: Jeongjun Park <aha310510@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)

On Jan 31, 2025, at 20:47, Jeongjun Park <aha310510@gmail.com> wrote:
>=20
> In the previous commit b3d82c2f2761, code was added to prevent journal =
sequence
> overflow. Among them, the code added to journal_entry_open() uses the
> bch2_fs_fatal_err_on() function to handle errors.

At least, bch2_journal_halt could invoke bch2_journal_halt_locked.

Is it possible to release the lock before bch2_fs_fatal_err_on() ? Not =
familiar with journal code yet.

>=20
> However, __journal_res_get() , which calls journal_entry_open() , =
calls
> journal_entry_open() while holding journal->lock , but =
bch2_fs_fatal_err_on()
> internally tries to acquire journal->lock , which results in a =
deadlock.
>=20
> Therefore, we need to add bch2_fs_fatal_err_on_locked() to handle =
fatal errors
> even when journal->lock is held.
>=20
> Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
> fs/bcachefs/error.c   |  6 ++++++
> fs/bcachefs/error.h   | 16 ++++++++++++++++
> fs/bcachefs/journal.c | 10 +++++++++-
> fs/bcachefs/journal.h |  1 +
> fs/bcachefs/super.c   | 11 +++++++++++
> fs/bcachefs/super.h   |  1 +
> 6 files changed, 44 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
> index 038da6a61f6b..25f51dec732d 100644
> --- a/fs/bcachefs/error.c
> +++ b/fs/bcachefs/error.c
> @@ -50,6 +50,12 @@ void bch2_fatal_error(struct bch_fs *c)
> bch_err(c, "fatal error - emergency read only");
> }
>=20
> +void bch2_fatal_error_locked(struct bch_fs *c)
> +{
> + if (bch2_fs_emergency_read_only_locked(c))
> + bch_err(c, "fatal error - emergency read only");
> +}
> +
> void bch2_io_error_work(struct work_struct *work)
> {
> struct bch_dev *ca =3D container_of(work, struct bch_dev, =
io_error_work);
> diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
> index 7acf2a27ca28..760623c07e67 100644
> --- a/fs/bcachefs/error.h
> +++ b/fs/bcachefs/error.h
> @@ -189,6 +189,7 @@ do { \
>  */
>=20
> void bch2_fatal_error(struct bch_fs *);
> +void bch2_fatal_error_locked(struct bch_fs *);
>=20
> #define bch2_fs_fatal_error(c, _msg, ...) \
> do { \
> @@ -205,6 +206,21 @@ do { \
> _ret; \
> })
>=20
> +#define bch2_fs_fatal_error_locked(c, _msg, ...) \
> +do { \
> + bch_err(c, "%s(): fatal error " _msg, __func__, ##__VA_ARGS__); \
> + bch2_fatal_error_locked(c); \
> +} while (0)
> +
> +#define bch2_fs_fatal_err_on_locked(cond, c, ...) \
> +({ \
> + bool _ret =3D unlikely(!!(cond)); \
> + \
> + if (_ret) \
> + bch2_fs_fatal_error_locked(c, __VA_ARGS__); \
> + _ret; \
> +})
> +
> /*
>  * IO errors: either recoverable metadata IO (because we have =
replicas), or data
>  * IO - we need to log it and print out a message, but we don't =
(necessarily)
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 2cd20114b74b..12e3b4024494 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -320,6 +320,14 @@ void bch2_journal_halt(struct journal *j)
> spin_unlock(&j->lock);
> }
>=20
> +void bch2_journal_halt_locked(struct journal *j)
> +{
> + __journal_entry_close(j, JOURNAL_ENTRY_ERROR_VAL, true);
> + if (!j->err_seq)
> + j->err_seq =3D journal_cur_seq(j);
> + journal_wake(j);
> +}
> +
> static bool journal_entry_want_write(struct journal *j)
> {
> bool ret =3D !journal_entry_is_open(j) ||
> @@ -382,7 +390,7 @@ static int journal_entry_open(struct journal *j)
> if (nr_unwritten_journal_entries(j) =3D=3D ARRAY_SIZE(j->buf))
> return JOURNAL_ERR_max_in_flight;
>=20
> - if (bch2_fs_fatal_err_on(journal_cur_seq(j) >=3D JOURNAL_SEQ_MAX,
> + if (bch2_fs_fatal_err_on_locked(journal_cur_seq(j) >=3D =
JOURNAL_SEQ_MAX,
> c, "cannot start: journal seq overflow"))
> return JOURNAL_ERR_insufficient_devices; /* -EROFS */
>=20
> diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> index cb0df0663946..416fbed447de 100644
> --- a/fs/bcachefs/journal.h
> +++ b/fs/bcachefs/journal.h
> @@ -408,6 +408,7 @@ bool bch2_journal_noflush_seq(struct journal *, =
u64, u64);
> int bch2_journal_meta(struct journal *);
>=20
> void bch2_journal_halt(struct journal *);
> +void bch2_journal_halt_locked(struct journal *);
>=20
> static inline int bch2_journal_error(struct journal *j)
> {
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index d97ea7bd1171..6d97d412fed9 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -411,6 +411,17 @@ bool bch2_fs_emergency_read_only(struct bch_fs =
*c)
> return ret;
> }
>=20
> +bool bch2_fs_emergency_read_only_locked(struct bch_fs *c)
> +{
> + bool ret =3D !test_and_set_bit(BCH_FS_emergency_ro, &c->flags);
> +
> + bch2_journal_halt_locked(&c->journal);
> + bch2_fs_read_only_async(c);
> +
> + wake_up(&bch2_read_only_wait);
> + return ret;
> +}
> +
> static int bch2_fs_read_write_late(struct bch_fs *c)
> {
> int ret;
> diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
> index fa6d52216510..04f8287eff5c 100644
> --- a/fs/bcachefs/super.h
> +++ b/fs/bcachefs/super.h
> @@ -29,6 +29,7 @@ int bch2_dev_resize(struct bch_fs *, struct bch_dev =
*, u64);
> struct bch_dev *bch2_dev_lookup(struct bch_fs *, const char *);
>=20
> bool bch2_fs_emergency_read_only(struct bch_fs *);
> +bool bch2_fs_emergency_read_only_locked(struct bch_fs *);
> void bch2_fs_read_only(struct bch_fs *);
>=20
> int bch2_fs_read_write(struct bch_fs *);
> --
>=20

