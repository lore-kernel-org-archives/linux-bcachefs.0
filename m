Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4138B18FDA5
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jun 2025 03:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750995268; cv=none; b=CQEQ1Xzt7EB0E4ie6DY0TiBayt3WYHQsidBcWwBuEWH+xt97Ec6HPUve+nCSfHmif1yD/sboiwM8n6XH9Fj39XieGmA7xXRtl98fq/toqyMCNbRFq92tvyLaIL/LJjgzAlq61NazqwlFiMbb8V1eMIJ059KpKQ2IEewGiHfgsys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750995268; c=relaxed/simple;
	bh=lXRZR/d6O9tEcFVYGrcUpjLKcSrBYWsy+lSFWL0ItJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQeguEFEz5qVkUVqyijkDplYmmrS9aqnU9k6MllP+4aSKTvLOcY0NJKMOI02ZglAUfq7Tf4M1ztOA0RmebDCIiRnuZaJhhhnZ8JO2w/gqwDld15sbvYYz+y966FYECSKl8qplt3gAJTKWKbbbgzkWCd6sC9G9T6AQGafrbIFWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mjQ7AYYF; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mjQ7AYYF"
Date: Thu, 26 Jun 2025 23:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750995254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r2Dsq66WVPXbBaG0lBEK/iXNVNpmsvGbhJpB9H2vDdM=;
	b=mjQ7AYYF7Urcw2dMcvsLHyrz/9wVudnZA9/5pJFJgFjAdVpY1/yY45RZA3hZK4Dv23NrI4
	FdF1bxISpVpUbf2GU4eLZgMhhevJ+jG6gjAj7/ROe9zQ2WiwhUgUGBUbxhdmJ4yuz/TZWk
	U9RnZMqzP7wbGyAu083Qi09h0TpwaNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kerenl@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
Message-ID: <xl2fyyjk4kjcszcgypirhoyflxojzeyxkzoevvxsmo26mklq7i@jw2ou76lh2py>
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
 <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 26, 2025 at 08:21:23PM -0700, Linus Torvalds wrote:
> On Thu, 26 Jun 2025 at 19:23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > per the maintainer thread discussion and precedent in xfs and btrfs
> > for repair code in RCs, journal_rewind is again included
> 
> I have pulled this, but also as per that discussion, I think we'll be
> parting ways in the 6.17 merge window.
> 
> You made it very clear that I can't even question any bug-fixes and I
> should just pull anything and everything.

Linus, I'm not trying to say you can't have any say in bcachefs. Not at
all.

I positively enjoy working with you - when you're not being a dick, but
you can be genuinely impossible sometimes. A lot of times...

When bcachefs was getting merged, I got comments from another filesystem
maintainer that were pretty much "great! we finally have a filesystem
maintainer who can stand up to Linus!".

And having been on the receiving end of a lot of venting from them about
what was going on... And more that I won't get into...

I don't want to be in that position.

I'm just not going to have any sense of humour where user data integrity
is concerned or making sure users have the bugfixes they need.

Like I said - all I've been wanting is for you to tone it down and stop
holding pull requests over my head as THE place to have that discussion. 

You have genuinely good ideas, and you're bloody sharp. It is FUN
getting shit done with you when we're not battling.

But you have to understand the constraints people are under. Not just
myself.
