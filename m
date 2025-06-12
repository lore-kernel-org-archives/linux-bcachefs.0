Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C77717BBF
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738615; cv=none; b=HMEv4ZJF9gvbF2aSOFZmK6ntymRSGdCAoNi2863a39TWtzPK0oGJKHeOirjEteigfjN4pARRtpjyQK8TD4lX5X+PI8+3YH2AIDAmVyPNgu+cOcI0uHpBra9cPkRzKjlTIkIMaFoGtdcHnG78uAWlBPqj7sJAKYYdeIR6iudaW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738615; c=relaxed/simple;
	bh=VVskwVKrFcFCP9B1S+hw3gZyL1S9rIaniXDzsWlbfVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dkO2PoJvYL11TQRTRKrEXMlPdeRuNH5yqxyP6mJa3JBwfnJAOHwqSUHYD9QX3REiiovx69wxGQQE+3q8M1DR7X2Ahf1NIgtt5zNl1sH7eqkEcfW7bb/8VX2R2dJjFpi4OG/eY0a3sOwvMiPiOZoyYmZRWISJfcygfPu4ieEhZ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 9173710AD90;
	Thu, 12 Jun 2025 14:30:09 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Date: Thu, 12 Jun 2025 16:30:08 +0200
Message-ID: <3358454.aeNJFYEL58@lichtvoll.de>
In-Reply-To: <5etvxpcqguoxh6trjsvxk2pfjap5otsj5kf7ioz67fznhlgzi6@vav7ef3xpyww>
References:
 <3009813.e9J7NaK4W3@lichtvoll.de> <2229760.irdbgypaU6@lichtvoll.de>
 <5etvxpcqguoxh6trjsvxk2pfjap5otsj5kf7ioz67fznhlgzi6@vav7ef3xpyww>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Kent Overstreet - 12.06.25, 15:45:23 CEST:
> > I suppose I could just create a new directory and move over the files
> > from the one with the odd size.
> >=20
> > However, keeping as is for now. Maybe I can help testing repair code.
> > =F0=9F=99=82
> Well, I do need to work on making the rest of the fsck passes work
> online, maybe I'll be able to start on that soon... fingers crossed =F0=
=9F=99=82

Would you like me to wait for that for testing?

I am not really in any hurry to fix this up.

Otherwise I could use the offline fsck.

Best,
=2D-=20
Martin


