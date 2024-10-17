Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A271DEFE5
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729183779; cv=none; b=kHg3srw8ScNDzphFyzYGTxNhMMbix+C0gmgwW/8UtgfzYGrjgekXr7llvFLAiDSvS5ZxYfyvaaCRcfgpfLFZAqsyaJgfj2RWlHaUvnPFzZkR8mLgVF0ABhVfNR9mSiQ250rVJOE3TnVm2yrrwp8PuVR61I95pWWeZypLjLP1eJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729183779; c=relaxed/simple;
	bh=VBF8q7vrnsF9n4+xcz+tytFj8D8SZmc7jjz6Hua3ht0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=uTYZu6c1l2D3GvABvoDPRvfuPjbnmGrh6ZdyYwYF00+EAiZNDF8/0Q4MkNh4gttAdUxu/M8ViKhq9w4Z0hLazifUyqhGpmGOd6Bvfeb3huAmdz9N7un5aREHMUIhrSMf7CFK2HylMSF1ls5EWvBejp2SiAsZFvkSDU/nD3AYbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 52E7630192CD0;
	Thu, 17 Oct 2024 09:49:33 -0700 (PDT)
Date: Thu, 17 Oct 2024 09:49:33 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <504302838.942.1729183773058@mail.carlthompson.net>
In-Reply-To: <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
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



> On 2024-10-17 3:13 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:

> ...

> Carl, I'm happy to fix bugs that you find, but the attitude and the
> unnecessary advice - that I don't enjoy.

Seriously, Kent? **You're** talking to **me** about attitude?

**You're** giving **me** passive-aggressive attitude about how I'm reporting a bug when using a kernel which is only 4 months old. And how about that crack about about how I should have just done an fsck when you knew (should have known) that a fsck doesn't fix the problem? I don't doubt that in your mind those are subtle insults that would fly right over my head and I wouldn't notice but I might suggest that other people aren't quite the idiots you seem to always assume we are.

I'm trying to **help** you, Kent. And that includes the reminder about how long it takes to put mostly-done software into a usable state. That's not attitude, that's just reality.

Carl
