Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47CDC147
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729158323; cv=none; b=kBzQ1mPU+z+xhx98FUrhjL3fjJldAPdF70YMFMQKmSzDdoqAojWHVRorXeOIENoT/jcSxPm08ktR03BgpTL8vM63kgqOzM5JBppqV7xfaks65nSD1lK5M30SmkIrKMAlZfSdRQrpeUeS+0LHXCDhzCDNFYQJMNrsdHRreFr0Zeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729158323; c=relaxed/simple;
	bh=CsLQyVugFN0vmuydA15sBVWLc56YV6dfSevfypKLutQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ju9DptetnWbQeqsWkNkXphQk8lEV4rq58DUNWrKwF/3uNWnJCQRo3XHIVPP7hkjeZzajz0G78YbjLBVSgvANHQH8vNPXkT6mm5n/p9yJZ+g6AumbRNhV/OYeP/BlQ4gB4hpnNJhsl78/BN6d5RCOmM9LaDPcX4Upk1JCBiYLwWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 675B319E461;
	Thu, 17 Oct 2024 02:45:19 -0700 (PDT)
Date: Thu, 17 Oct 2024 02:45:19 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <884724407.902.1729158319260@mail.carlthompson.net>
In-Reply-To: <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
Subject: Re: Another bcachefs version downgrade bug
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite


> On 2024-10-17 2:30 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:

> ...

> Honestly not warrented at this point, things have been stabilizing fast
> and I'm likely 6 months or so from taking the experimental label off.

Remember the 80/20 rule. I suspect that may be (should be) further away than we might like.

Carl
