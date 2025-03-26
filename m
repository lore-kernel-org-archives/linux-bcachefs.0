Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518EC1F3B9C
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008731; cv=none; b=amkVDv+UwF4Kzhc+cWY0F5+FxXDutsfW25tXbDcfkOpVjut0PYMSbOVwMtF7OfL9SxEQiorierSNDJ5lGOc7wfx8BfnQYmDnL6jthUzLBfvLPkzLOFrhDqO9bR1ZzOks81uBScguXx/GKYBjJno1Gq2q9Kp3du8ty0Xw8poOfNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008731; c=relaxed/simple;
	bh=EppiJDvO33gydWBIyW0r22bPtgqyv/3Q/ZpsaPqZP4o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkrMfOEHpkaWSbkCA/EQ7BheyzW1XInTY1F0ZnpabYqQkdmdhA2JHvYfjXrIM4Xmg2FswiQgzVXmVEOyzNS0DScPzXxTIXSwHCbqEgpmgzSUfDBxDYXs/fC89tjuf2sUHulEj5xep9dFoz4ewtuNuGFwJqbGoIinb78kf4/zqRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=mu0+NCgn; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="mu0+NCgn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1743008721; x=1743267921;
	bh=R14kZJ+myWn+UELCwLDdhoNgVFBwZU+x8ANJXxnhGJA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=mu0+NCgn6SWsbz1ZrbBsfa7bFk7a9Vc6N7GH+DLVPy8htWimpxFtVKeWtboZuF7PF
	 mM+u6rUyQHar/z4+UB3L558ROPXcROk0Um860UT09LHRFM9YL8jy6KC4i+DuE7tltC
	 HUV+NJbj8KojIe4vG1x+lkCWBt8x4eN9z7tLUUQ3D6s5wNe3zf8HaZGQFBOlLLeNZ2
	 Uy6o8YTb3lRx7xJpd65O49zBVW3GgG8hsiDbegXxgz6wXYIgAs36btsZosiHHUUvg9
	 juJf+cSD3H4blRYM0PfLclG95cCGoEUMe39XVgchoK1lrJ5oHchJ67yUOpxlgNlpZn
	 KcShDfCWz7Nwg==
Date: Wed, 26 Mar 2025 17:05:17 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: Alan Huang <mmpgouride@gmail.com>, Bharadwaj Raju <bharadwaj.raju777@gmail.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
Message-ID: <ULxTq7SIKI8zZzvCtpIc1c4o41NFzejFbPTVQpNwBNjXjxVeJ-YOEShGUxw_uTLIYTiC0PEvER_FLWMDmD2SXc5NCpZ8wD-WxIA_RkpUzKs=@protonmail.com>
In-Reply-To: <rl77wgelda45zddkutitervzkxd4iip4mxoheglxinqizf4owm@zmub5beyi6x3>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com> <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com> <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce> <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com> <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e> <CAPZ5DTF+Q_-10xF915wF3b3aUm5jqZepqoyivF+G4S6ONf_PcQ@mail.gmail.com> <vfszytfd66lqj54nmkymhnrdjodylb7l3alxblzixnlzv7kxom@4dji3xuvmknj> <A4568396-D1E1-4D93-851B-FA9CF9804E10@gmail.com> <rl77wgelda45zddkutitervzkxd4iip4mxoheglxinqizf4owm@zmub5beyi6x3>
Feedback-ID: 136600343:user:proton
X-Pm-Message-ID: 87eb72cbcdb410d097c9c6183d426c4ec761f885
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wednesday, March 26th, 2025 at 5:41 PM, Kent Overstreet <kent.overstreet=
@linux.dev> wrote:

> On Thu, Mar 27, 2025 at 12:36:25AM +0800, Alan Huang wrote:
>=20
> > On Mar 27, 2025, at 00:17, Kent Overstreet kent.overstreet@linux.dev wr=
ote:
> >=20
> > > On Wed, Mar 26, 2025 at 09:19:06PM +0530, Bharadwaj Raju wrote:
> > >=20
> > > > On Wed, Mar 26, 2025 at 8:22=E2=80=AFPM Kent Overstreet
> > > > kent.overstreet@linux.dev wrote:
> > > >=20
> > > > > Or better, a new helper: when we're copying to a fixed size buffe=
r we
> > > > > really want to zero out the rest of the buffer - we don't just wa=
nt a
> > > > > single terminating nul.
> > > >=20
> > > > I believe strscpy_pad does this?
> > > >=20
> > > > https://docs.kernel.org/core-api/kernel-api.html#c.strscpy_pad
> > >=20
> > > almost, we don't want the 'required nul termination'; that's a
> > > requirement at least for disk labels where we need to preserve existi=
ng
> > > behaviour
> >=20
> > memcpy_and_pad :)
>=20
>=20
> I'll take that patch :)

I'll send a follow-up patch with memcpy_and_pad with the pad_char=3D0. Even=
 though strscpy_pad does not require it, it does make the assumption that t=
he destination buffer should be NUL-terminated, and it does some extra chec=
ks we don't need, so memcpy_and_pad is the way to go.
=20
I'll also replace the memcpy calls in bch2_trans_log_msg() and __bch2_fs_lo=
g_ms().  
