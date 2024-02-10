Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EDF5DF24
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Feb 2024 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707590662; cv=none; b=cLzifXz5R0mRLL8+VQtwswv4UaSgd6XCGtvSdDIoIZ1yDtpCE1db1UxMwdAxA0k8C1QJMsMZ8ZvpcS84DinzOh4/qU3xiy0JOsv6WlUnidxscM0g007hf+fdhLBQqjFAS5uMIQvywNFJkxQz95L8D2NwPm6HRDa0nPgR/3NxB84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707590662; c=relaxed/simple;
	bh=ZlwbowTI/W6crCziPg27tbiT6i+eh4roYSyIR6Dbsbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u5WkCKW1t0bVPXc8EL6C8EUXpjLlunFowCMeOn7mmnDY3MO6qMIVq3rKhf0pH+P4mgOIyuV9Y4E9F5fWoZbS+tN8bUrilrPXuLs2nCno3sCHDP62I3aemT9BpFem2sg4Q8gF+tX2ohlkq3XRK5vFDO51Egg4Em8vAS2Ji1fy1ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 0EFBF892BCF;
	Sat, 10 Feb 2024 19:34:47 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: kent.overstreet@linux.dev, George Hilliard <thirtythreeforty@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, lkml@inml.grue.cc
Subject:
 Re: Error while unlocking encrypted BCacheFS: Required key not available
Date: Sat, 10 Feb 2024 19:34:46 +0100
Message-ID: <3282845.44csPzL39Z@lichtvoll.de>
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

Hi George, hi Kent, hi,

George Hilliard - 16.01.24, 18:59:08 CET:
> The workaround for users is to run:
> 
>     keyctl link @u @s
> 
> just before running `bcachefs mount`.

That workaround works for me. Thanks.

Copying several TB to a new external 4 TB SSD with BCacheFS currently :)

I will try the other workaround from the other thread as well.

Thanks,
-- 
Martin


