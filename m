Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D051CD27
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705429239; cv=none; b=KidGYOxaK9mX7i1WQGzbMbwE4ufGDbmzkMtaMs+aTPB90tpq5ENzpWsAAuUjI5+wK0CMp0wjedXFwWT8HS+g3qufhwCgQY4KvgAL1SEO6V8N/LohLWCukzQFv6lEBtkxU5gh+G4Q2s3+6ty1gqkeIUacTMaabfAxaUGxeDX7x6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705429239; c=relaxed/simple;
	bh=Oxls1VMTrsx7zeUiorNL5sRyR6BYpXJKZd8YIT7b3TU=;
	h=Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type; b=JCmSufHPbVn66T6zEldMnJhY0M+bMEzfPhk+K4QOayjiiW6fI9jYFx+Ca5ik+tRnDlKOLuMKAq6p5eDxlI6YnEGR0qyyEo7qOq7QZEpmybZMIypQ/I2bpXYDSO3kZwPfCvqMuBLF9sZnZeKb7QwlmmhE6vHX7cHkfAb6iU/MwBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 2AA8D872D20;
	Tue, 16 Jan 2024 19:20:28 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: kent.overstreet@linux.dev, George Hilliard <thirtythreeforty@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, lkml@inml.grue.cc
Subject:
 Re: Error while unlocking encrypted BCacheFS: Required key not available
Date: Tue, 16 Jan 2024 19:20:27 +0100
Message-ID: <1894445.CQOukoFCf9@lichtvoll.de>
In-Reply-To:
 <CACmrr9gQeXccyS9ZRiR2KnTKnA6EVBCVz_YWcDC3p1mbGqgMSg@mail.gmail.com>
References:
 <CACmrr9gQeXccyS9ZRiR2KnTKnA6EVBCVz_YWcDC3p1mbGqgMSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

George Hilliard - 16.01.24, 18:59:08 CET:
> Some other folks have found similar problems with other uses of keyctl,
> see [1]. It appears systemd segments each system service into its own
> kernel keyring. Presumably the one bcachefs-tools is writing into, is
> not the one the kernel is reading during mount.

I use Devuan with Runit, so no Systemd involved. However elogind is in 
use. Maybe a function of systemd-logind / elogind?

> The workaround for users is to run:
> 
>     keyctl link @u @s
> 
> just before running `bcachefs mount`.

I will be trying this out and report back. Thanks!

> I am not enough of an expert with kernel keyrings to know whether the
> kernel code, systemd, Arch's packaging, or something else is at fault
> here.

From what I gathered so far there is some complexity involved here, as 
seems to be usual when it comes to encryption.

Best,
-- 
Martin


