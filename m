Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B4B1F4179
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000037; cv=none; b=YqS+A7hxM8J1g+el3ASFrEITIXSlQ0zPMbBMU1LbArnYXHgtTVyYHe9Nb8kD51HTGcBcvLFV67G10jDvMh4VqSzO0a5k6FpNIfubaW39UD6nPn+ceOSKpVgF/LPBne6k6X6sbDE4afTNUNDpZ3ns4HryNxhaZ6FMJ2Pm899Xb7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000037; c=relaxed/simple;
	bh=NhFS2xLNre0w5sO/psixMK+yUzp52cYXeu8XFV5AqXw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IoIH6hYNXacDE0Rrh7N1qaRV38y/c4Jnlwto7dCyXADbpHJobCnMqp/Pm77dTBR16PkUo8ilfhVxuB8drlTYDhM0Ltj20VXQL0ANOwXokR+v7Lu4SuLzwTJCVwnshlPdEIZMl/w7siedj0usuirgxZTJIEyeTSdKlB0ualI+iE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=MgEc86Ne; arc=none smtp.client-ip=79.135.106.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="MgEc86Ne"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1743000027; x=1743259227;
	bh=dzTVrQAs4tUHsA7Uxq5scKB6ckWpWt33uALDQeW4FGY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=MgEc86NeNQgGKieWk9tXIUbd4aA0tDaryUFjYClugITJ0fkj7kHkosHxdlAJEz5/g
	 APq+zn7yzztP2Gm0XmjeZIMgNagYglyNfaD89UAfk5SQEAEt5spzJBxz9GDJGwNCUi
	 8HB+ulE42vErViapmhfXIim+wgKnixO0ULlvFSjH9YTn42tFsHzkZ9qyB001CmMbKH
	 VWk3e+Hh9TEYlC92nJiBeo567WNHHMxTY1L7xaFpHoAT+L4rJiR+MDD3CCicuOaMzV
	 xQ5tFXwQB20AH+pk05ViZDhEvo1Bd6nji7eg0ZZshD2o4uqF6yyRtqBZI4HxoIoRHP
	 I5+SBx8pqPz8A==
Date: Wed, 26 Mar 2025 14:40:22 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
Message-ID: <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
In-Reply-To: <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com> <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com> <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
Feedback-ID: 136600343:user:proton
X-Pm-Message-ID: 8a00fd24fd1286f6f3d4dce5e7eee046f1279d9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wednesday, March 26th, 2025 at 1:19 PM, Kent Overstreet <kent.overstreet=
@linux.dev> wrote:

> On Wed, Mar 26, 2025 at 06:02:31PM +0800, Alan Huang wrote:
>=20
> > On Mar 26, 2025, at 17:44, Roxana Nicolescu nicolescu.roxana@protonmail=
.com wrote:
> >=20
> > > strncpy() is deprecated for NUL-terminated destination buffers. Use
> > > strscpy() instead.
> > >=20
> > > Link: https://github.com/KSPP/linux/issues/90
> > > Signed-off-by: Roxana Nicolescu nicolescu.roxana@protonmail.com
> > > ---
> > > fs/bcachefs/btree_trans_commit.c | 2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_tra=
ns_commit.c
> > > index c4f524b2ca9a..7ab25b425d11 100644
> > > --- a/fs/bcachefs/btree_trans_commit.c
> > > +++ b/fs/bcachefs/btree_trans_commit.c
> > > @@ -364,7 +364,7 @@ static noinline void journal_transaction_name(str=
uct btree_trans *trans)
> > > struct jset_entry_log *l =3D
> > > container_of(entry, struct jset_entry_log, entry);
> > >=20
> > > - strncpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> > > + strscpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> >=20
> > The last time I asked Kent about this line, he didn=E2=80=99t want this=
.
>=20
>=20
> Yes, the destination buffer isn't required to be nul terminated.
>=20
> But it seems we should add a comment explaining that :)

I should have checked the mailing list before, but I will keep this in mind=
 for my next contributions.
I wonder if we should use memcpy in this case. This is also recommended by =
the security team here https://github.com/KSPP/linux/issues/90
This will also prevent other people from trying to send a similar patch in =
the future. 
