Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7633B132C3D;
	Thu, 15 Feb 2024 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708011365; cv=none; b=UevLvZHOza09PqyNKhlhaXwP4+HgCuwO+x3szDcEnywV6GlPO2Q21gEX4mUfh5ZGv0lb2Kzt+Of8J16KyJZh7v+Mkl2uAyxZOR2n0QXFgId+rh+M83ZfXAeB3l/fbo3WDPqBjubhCZMf/odG2W1hNjcASh1K8+a0MYymiDzews0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708011365; c=relaxed/simple;
	bh=1p3Q3KdbxlHlmdeFhlNImxogJYDY5dAaY8ePBASP6co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+FJ6hrcPtW7wP4sghGIPuRIJ6AbfeRQitv1zPCeU30Sc68vMgYqlrPi15K3qcd871eVY6rgC1vRxoXfRO+Z9bKxTX3PPdTB3xcp7+O33W1S4tTVNEHABT551/XVQ2AWgcL0dD4LjN5G2BjKMX3YOz9P4nKr9pqgoPDAtZKjsK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id A762989B9A2;
	Thu, 15 Feb 2024 16:36:00 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, stable@vger.kernel.org,
 regressions@lists.linux.dev, linux-usb@vger.kernel.org,
 Holger =?ISO-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
 linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Date: Thu, 15 Feb 2024 16:36:00 +0100
Message-ID: <2140271.OBFZWjSADL@lichtvoll.de>
In-Reply-To: <eec1464d-4e9f-48b5-b619-868f0e5c1d4d@rowland.harvard.edu>
References:
 <1854085.atdPhlSkOF@lichtvoll.de> <1979818.usQuhbGJ8B@lichtvoll.de>
 <eec1464d-4e9f-48b5-b619-868f0e5c1d4d@rowland.harvard.edu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Alan Stern - 15.02.24, 16:19:54 CET:
> > First I will have a look on how to see what USB power management
> > options may be in place and how to tell Linux to keep the USB port
> > the SSD is connected to at all times.
> > 
> > Let's see how this story unfolds. At least I am in no hurry about it.
> 
> This may not be an issue of power management but rather one of
> insufficient power.  A laptop may not provide enough power through its
> USB ports for the Transcend SSD to work properly under load.
> 
> You can test this by connecting a powered UBS-3 hub between the laptop
> and the drive.

Interesting idea. Maybe the Transcend XS-2000 4TB needs more power than 
the Sandisk Extreme Pro 2TB.

Not sure whether I have one at hand with USB-C here, cause my regular USB 
hub only has USB-A connectors. Need to look for one with enough USB-A and 
USB-C connectors as I use an USB hub as replacement for a docking station. 
But I do have at least optionally powered hub with USB-C one at another 
place. It does not have many ports. But for the task ahead one USB-C port 
is sufficient.

I will try this as well. Thanks.

Best,
-- 
Martin


