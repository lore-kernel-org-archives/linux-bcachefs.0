Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3F23D282
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Jul 2025 22:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751926234; cv=none; b=AniMFbsyglOBnZX4louX8214Dn50kW6lfeF0SmmBml2x5+CchJJ0WKb+qQ+HwkBnhSuesLyW6tsX7li4SvqibRgIlFmyTxRYn5Z3T3HuJsCoMRHz9rwKdxTbAw/XtmTgwmn8jOkI0ZV7hP/qL77IeTBl83I5ggH+3VvEn72sKjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751926234; c=relaxed/simple;
	bh=3zJvL/Iq+WQkGgLrEZXY9jOsyRQJ5P9dPP1UN2/RHvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3lu6IxGZhQSmnprs4BfHb1yqSzrFSFCjMu7T6ExNHCqKH47Vf7KejPQjgjr4xKkJE9jfnOoZI+MQ66VvjC5EZ/LjM85MPOfLbl8jCzddlGSMNLj0hF/2CIOGuP7KQAHm+CmSZ0B/P6sT373d8eb4KCJ6qZG1jXFsarpVpj1/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KwRRityf; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KwRRityf"
Date: Mon, 7 Jul 2025 18:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751926230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UQ6Q/E4DsPgBO04mVst9b2j/4S+3xGkb4laMNT1RNks=;
	b=KwRRityfV+NRf+jYgnpGtxvJ9Z7Cu0M8QePsr8FOwB4O+4jYz3Psj/CzyWN7/FOUfeAMSD
	sVWtYoWaEOCkA/wq9yrdgyHVnTJLnGaB3fXcTIS1Y14hgT6S2CLQxKM12QA0974DBRckk7
	pNJAPS9880Ph1alN2Xl0rOjVc4xPBIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jani Partanen <jiipee@sotapeli.fi>
Cc: John Stoffel <john@stoffel.org>, linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
Message-ID: <3hksvubirxxsro7rtjxpzzomo26my4atsyp5m6udglv6mtf4op@mocpq57xztlj>
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
 <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
 <xl2fyyjk4kjcszcgypirhoyflxojzeyxkzoevvxsmo26mklq7i@jw2ou76lh2py>
 <26723.62463.967566.748222@quad.stoffel.home>
 <gq2c4qlivewr2j5tp6cubfouvr42jww4ilhx3l55cxmbeotejk@emoy2z2ztmi2>
 <26732.10255.420410.321937@quad.stoffel.home>
 <r2ibma56tp7mwqepp7ksenmcrildo6n4wnmj3aa7l3vdpyk26r@42azsnav5bm2>
 <ebbe21e2-f353-4ccb-b41d-7f7698de1eb1@sotapeli.fi>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebbe21e2-f353-4ccb-b41d-7f7698de1eb1@sotapeli.fi>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 08, 2025 at 12:35:19AM +0300, Jani Partanen wrote:
> Maybe you should find some front(man/woman/person) who deals pull requests
> and other communication. You clearly cannot do both, code and communicate.
> And there is nothing wrong about that. Not everyone is good with
> communication. I will base my claim to what I have seen here. Drama after
> drama and very stupid reasons.

There's been a lot of misunderstanding about what the job of deciding
what patches go out when and sending pull requests entails. Some of it
is communication, but not the majority.

A partial list of responsibilities includes:

- Following and triaging bug reports
- Keeping in active communication with users who are QAing
- Watching test dashboards (and this is a big one, we collect a ton of
  test data)
- Understanding the coverage of those tests (and realistically, this
  means we'll need automated code coverage analysis before someone new
  can take it over)

It also requires a fairly intimate knowledge of the codebase and the
engineering techniques we use for assuring correctness, as well as deep
filesystem experience to understand the different "gotchas" that can
happen.

It's a serious job with serious responsibilites, and not something to be
handed over lightly.

Were you volunteering to take all that on? I do spend time teaching
those who are willing :)
