Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064B61D9A49
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 21:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742331861; cv=none; b=MBpdYVtufJMnCnGRspireITe+2D73NXXkEQ+yP1jJOAlwB0M3MwDoocdiwGS/Se9mxV/xJoUguReCVeFaKBRZeM4K9quzTNg1+/oH9WfPZAR0niQK1gLHlPoZwVEaHnWsYrvlOIBSgI2ucDv8iZ5elEgQd96JGHkfJvLjS1ib60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742331861; c=relaxed/simple;
	bh=ZgG1Afab0oNayzfSK5suCJ0hn2XDP9WXD/fsp44hJbQ=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=mtWCgNAfYyaAOXKBbqdbRQm90Swa0cpUEkIkIFD3d3mAIPaB+oBhszVxBch41WPhOlY7hNT4hlqsMsu/bKTktBG3v+PaVoOUhJlzWvW7kITX76X0aDyZIhJTRu9mqGT39iJgCtQW+o2cKAXcVaiyL6RWtXXyuLYElrXnAqq1qAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 7617A1E4E0;
	Tue, 18 Mar 2025 17:04:12 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id C9FF6A0E84; Tue, 18 Mar 2025 17:04:11 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Message-ID: <26585.57291.760395.430511@quad.stoffel.home>
Date: Tue, 18 Mar 2025 17:04:11 -0400
From: "John Stoffel" <john@stoffel.org>
To: Malte =?iso-8859-1?Q?Schr=F6der?= <malte.schroeder@tnxip.de>
Cc: John Stoffel <john@stoffel.org>,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: errors compiling bcachefs-tools v1.20.0 on debian 12
In-Reply-To: <66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
	<26584.35900.850011.320586@quad.stoffel.home>
	<26584.36927.6100.282713@quad.stoffel.home>
	<66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Malte" =3D=3D Malte Schr=F6der <malte.schroeder@tnxip.de> writes:

> Libs in Debian 12/Bookworm are too old for bcachefs-tools. I think
> someone pulled it of by forcing some libs from Trixie, but that caused
> other things to break.

So what is the best Linux distro to use to compile bcachefs-tools?
And can someone upgrade the INSTALL.md doc and the
https://bcachefs.org website to talk about what is the best
development environment now to use as a baseline?  And how to
cross-compile the bcachefs-tools for use on older distros with newer
kernels?=20=20

I'm sure more people would test and play with bcachefs if there was
more docs for ends users to work from.

John



