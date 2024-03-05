Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39845C83
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Mar 2024 00:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599773; cv=none; b=sHWLm9dA9qAik0/EoWhD9Yhs5AoEg4cCJ2H08h134poAoKOcGZrMNMJupr8hDiPv/F4O7cE3EK+gs9+RT/mShMZZQB2TjjJNLnBveU5N5nCDAFzMBqZjuvvCXYIWGw3jfT2mq2OxGlhBlNdxzd6/8WoYiXkl2MQxMe+98WEcEMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599773; c=relaxed/simple;
	bh=yDKlLOOAx6BSlxy3qKeVFSv5O+VniTuWGGQ6sRcsXn8=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSD6VHQuBQAza3KdTs0QJPlOgVierY7QIOFllrci11vljW+A4SgK3FQP0bCKhFNhOKEwfTrUZBL4Y1OH68PDRxLAqNnN4Hxas7gnAUMmZVjG5j+RONkP/CiWylnfe+yx7MHpxWzxFTmnqCKeUad5z9kP944tWR+z0ofMWKefAUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RP6Miz8I; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7jtEuzYw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RP6Miz8I; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7jtEuzYw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RP6Miz8I";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7jtEuzYw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RP6Miz8I";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7jtEuzYw"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B27D35C730
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Mar 2024 00:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709599769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PNtUw/aR8lIs6S5tAhOsrDz5D4n/FsWf0cxGM1V3iFA=;
	b=RP6Miz8I+xeoHYFDAQxemHyPRTBLfpw3MOmSOlnOiWPVfsSSHNbih1KchjHaEh46ceOqtO
	4axIMgmZ55lz1R1P9zARlJl2S48ppkQd5065D5OmJFd7Ze1n6Y9ioAKtWYnBpaK+01HCQ9
	GTKTLqlsc/idmXrZ4twlxR+9TNSrQxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709599769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PNtUw/aR8lIs6S5tAhOsrDz5D4n/FsWf0cxGM1V3iFA=;
	b=7jtEuzYwqfWgmFseK5RblSEJEtIPlOuy7q5X1LhLcZDpW1KktTnxYeSyitrNsMiHrA3VNL
	WUBw9veS7iWMPfBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709599769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PNtUw/aR8lIs6S5tAhOsrDz5D4n/FsWf0cxGM1V3iFA=;
	b=RP6Miz8I+xeoHYFDAQxemHyPRTBLfpw3MOmSOlnOiWPVfsSSHNbih1KchjHaEh46ceOqtO
	4axIMgmZ55lz1R1P9zARlJl2S48ppkQd5065D5OmJFd7Ze1n6Y9ioAKtWYnBpaK+01HCQ9
	GTKTLqlsc/idmXrZ4twlxR+9TNSrQxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709599769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PNtUw/aR8lIs6S5tAhOsrDz5D4n/FsWf0cxGM1V3iFA=;
	b=7jtEuzYwqfWgmFseK5RblSEJEtIPlOuy7q5X1LhLcZDpW1KktTnxYeSyitrNsMiHrA3VNL
	WUBw9veS7iWMPfBA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id B883613419
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Mar 2024 00:49:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 3MUHGhhs5mU/dAAAn2gu4w
	(envelope-from <ddiss@suse.de>)
	for <linux-bcachefs@vger.kernel.org>; Tue, 05 Mar 2024 00:49:28 +0000
Date: Tue, 5 Mar 2024 11:49:09 +1100
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] make-release-tarball.sh: run cargo audit
Message-ID: <20240305114909.537c6080@echidna>
In-Reply-To: <20240130070356.8174-1-ddiss@suse.de>
References: <20240130070356.8174-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RP6Miz8I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7jtEuzYw
X-Spamd-Result: default: False [-2.51 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCVD_DKIM_ARC_DNSWL_HI(-1.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[linux-bcachefs@vger.kernel.org];
	 TO_DN_NONE(0.00)[];
	 DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 RCPT_COUNT_ONE(0.00)[1];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_IN_DNSWL_HI(-0.50)[2a07:de40:b281:106:10:150:64:167:received];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-1.20)[89.13%]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B27D35C730
X-Spam-Level: 
X-Spam-Score: -2.51
X-Spam-Flag: NO

Any feedback on this change?

Thanks, David

On Tue, 30 Jan 2024 18:03:56 +1100, David Disseldorp wrote:

> cargo audit can be used to check bcachefs dependencies for
> vulnerabilities published in the advisory database at
> https://github.com/RustSec/advisory-db.git
>=20
> Given the significant size of dependency sources (currently ~292M),
> manual audit is mostly unviable, so rely on this for now.
>=20
> Audit failure will halt tarball generation with e.g. v1.4.1:
>     Fetching advisory database from `https://github.com/RustSec/advisory-=
db.git`
>       Loaded 595 security advisories (from /home/david/.cargo/advisory-db)
>     Updating crates.io index
>     Scanning rust-src/Cargo.lock for vulnerabilities (98 crate dependenci=
es)
> Crate:     shlex
> Version:   1.2.0
> Title:     Multiple issues involving quote API
> Date:      2024-01-21
> ID:        RUSTSEC-2024-0006
> URL:       https://rustsec.org/advisories/RUSTSEC-2024-0006
> Solution:  Upgrade to >=3D1.3.0
> Dependency tree:
> shlex 1.2.0
> =E2=94=94=E2=94=80=E2=94=80 bindgen 0.64.0
>     =E2=94=94=E2=94=80=E2=94=80 bch_bindgen 0.1.0
>         =E2=94=94=E2=94=80=E2=94=80 bcachefs-rust 0.3.1
>=20
> Crate:     atty
> Version:   0.2.14
> Warning:   unsound
> Title:     Potential unaligned read
> Date:      2021-07-04
> ID:        RUSTSEC-2021-0145
> URL:       https://rustsec.org/advisories/RUSTSEC-2021-0145
> Dependency tree:
> atty 0.2.14
> =E2=94=94=E2=94=80=E2=94=80 bcachefs-rust 0.3.1
>=20
> error: 1 vulnerability found!
> warning: 1 allowed warning found
>=20
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  make-release-tarball.sh | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/make-release-tarball.sh b/make-release-tarball.sh
> index c468da7..51875b0 100755
> --- a/make-release-tarball.sh
> +++ b/make-release-tarball.sh
> @@ -7,6 +7,8 @@ version=3D$1
>  git checkout v$version
>  git clean -xfd
> =20
> +cargo audit
> +
>  cargo license > COPYING.rust-dependencies
> =20
>  git ls-files|
