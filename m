Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A421823D7
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729470902; cv=none; b=Rhl+i+On6LVkuQvOiAqSwU1mGb9MhsjxPn1c9MWcKe3T/Ns0rGZFO93t9mZdOGEfHcYLQUvP4ElTqYNEhbfHjv1PegJfYXyIJzzoFYt4LETon8I9AJBmKvSIE/MxNTu1cQVabBaQ2nzSA35klGASOj2j9qCh2TnI2S01C30bt1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729470902; c=relaxed/simple;
	bh=rgBjVKDtt3J538gHRwJVFkyM+G+ATkUk9hrxfDNkYHs=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=i8gojYcYrtdI7CgLSM/f4u08e9I+q+4wT+Z2kLiuwD7RF7J5SnT2DNGTLxd8HNjmxKZyrYuFNgK9FsizGvf5vOAM5tx5oCAOvZ25bWr2QYVLR9FBaUZPvC5aOughmdQca30EUusVKRXoD1VVsGp9tsgUUrerKWQvC4bc97V+UJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id B3B9F1A730D;
	Sun, 20 Oct 2024 17:34:53 -0700 (PDT)
Date: Sun, 20 Oct 2024 17:34:53 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christopher Snowhill <chris@kode54.net>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <216190573.1599.1729470893479@mail.carlthompson.net>
In-Reply-To: <kadahbpbnfzxck7a5peye2rdvoi5w5omvhcloocqr5lypxrvse@tdddqahswipx>
References: <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
 <537913254.1059.1729273074517@mail.carlthompson.net>
 <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
 <kadahbpbnfzxck7a5peye2rdvoi5w5omvhcloocqr5lypxrvse@tdddqahswipx>
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


> On 2024-10-20 9:59 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:

> ...

> I have a lot of users and testers that I work with, and will bend over
> backwards for if something is broken, and to make sure data isn't lost.

Absolutely. We've all seen you do that over the years. That's a big part of the reason why users like me spend so much of our own time and resources testing and supporting your work.

> But I do draw a line at being demanding, or all the "constructive
> criticism" that comes with an attitude of "I know your job better than
> you do". 

And I'm not doing that. I'm simply reporting bugs and offering perspectives that you may not have thought of for your consideration. I don't demand that you do anything because I **can't** demand that you do anything. 

I'll give you an example. More than a year ago I raised the issue that bcachefs does not allow multiple versions/images of a filesystem to be mounted at the same time. I pointed out that there are several professional workflows that require this (forensics, auditing, etc) and non-professional workflows too (retrieving a previous version of a file from an LVM snapshot, etc). I pointed out that other modern filesystems allow it and argued that it is a needed feature. You disagreed that it is that important and have never (to date) implemented the feature. This causes me to have to create special-case workarounds specific to bcachefs which operate differently than what I do for every other filesystem. Despite this extra work and inconvenience for me I have never brought it up again, never nagged you and never demanded that you listen to me and change your mind. I made my pitch, you made your decision and I accept your decision even if I don't like it.

I give you my opinion and the logic behind it and you can choose to consider what I say or not. You have your decades of experience. I have my decades of experience. Despite my own considerable experience I've personally found that sometimes other people **can** make persuasive points that change my mind and can make a project better **if I'm open to them**.

It's really, really hard to tell what someone's attitude is over the internet. I'm sometimes guilty of trying to do that too and so in the cases where I've done that to you I apologize. But I assure you my intent when I make a comment is to **persuade** you and not to demand or force you to do anything.

> You wouldn't walk into someone's office and immediately start
> telling them how to do things, would you?

No, but that's an orthogonal argument. This isn't an office. This (the Linux kernel) is an open-source project that not only encourages open collaboration among many types of people **it absolutely requires it**. By most any objective measure Linux has been, still is and will continue to be by far the most successful, influential and dominant software project in the history of humanity and it's not even close. In my opinion that's a core reason why it rubs a lot of people the wrong way when you over and over seem to tell Linus and the other kernel developers "you're doing it wrong." (If I'm misinterpreting I apologize.) Now, you've definitely earned the right to voice your opinion but I'd advise taking a page from my book and making your point as eloquently as you can **once** and then let it go if they don't go for all of it. If you must, bring it up again periodically (I'd suggest annually) but of course that's just free advice (and worth every penny!) and you should do what you th
 ink is best in the way you think is best.

I'll also make the self-serving point that Linux isn't successfully only because of kernel developers like you it's just as much due to users like me. Back in the 90s I was once **literally** laughed out of a boardroom for presenting rationale for why my company should pivot from developing products on traditional Unices and start focusing our efforts on the new Linux thing. They disagreed; I left the company and within months they were out of business so I guess I got the last laugh. I didn't write fancy papers and become famous the way some people did back then but I have ever since relentlessly done my part by pushing every company I've worked for to be more successful by more fully leveraging the benefits of Linux. Now, of course, pretty much every company gets it. I advocate for Linux in my personal life too. And there are countless millions of other users who also contribute in their own ways big and small most of whom will never be known or even have conversations on kernel ma
 iling lists but who are just as important and integral to the success of Linux.

So there's a whole big picture thing to keep in mind.

> I don't suscribe to the modern theories about how we all have to be nice
> to each other and always use nice words

Well those theories are not at all modern concepts. Whether you call it karma, or the Golden Rule, or being neighborly, or modern political correctness, the idea that human societies work better when people work together and politely respect others' differences and opinions is ancient.

Now as a practical matter all human beings have egos and feelings. You could make an interesting theoretical logical argument that those things **shouldn't** matter in social interactions such as the development of software but my experience is that in reality those things matter **more than everything else** in **every** type of voluntary social interaction. 

One of the first hard lessons I learned in independent life is that it doesn't matter how smart you are if you can't get people to like you. If a large enough portion of the people around you don't like you they will keep sniping at you until you are (socially or professionally) dead. That's just a fact of life that's also true professionally and it's probably true here too. Should it be that way? The answer doesn't matter. For me, dealing with it professionally was initially an intellectual challenge; how do I get my coworkers to like me so that I (and my ideas) can be more successful? But the funny thing is I found out that purposefully expending effort to be nice so I can further my own success doesn't just make **me** more successful, it makes everyone else more successful too. And it has the unexpected benefit of making me **happier** too, which is something I need.

So while I understand your opinion it's not one I share.

> ...

> But you're complaining about an EOL kernel, where the issues have long
> been fixed, so in this case there's just not a lot I can do. I could ask
> Greg to cut a new 6.9 release, but all the distros have been told that
> 6.9 is EOL so it's not likely it would be widely deployed.

I am **not** complaining about an EOL kernel. I explicitly stated that I **didn't** need a fix. I simply reported a bug that affected me which I was unaware had been fixed.

I do think that if you find and fix a bug like that it would be nice for you to document it and let users know about it so we can possibly avoid wasting a lot of our time and effort unnecessarily.

> ...

> The ability to upgrade to a new on disk format, and then seamlessly
> downgrade - that hasn't been done before, keep that in mind, and that's
> an enormously useful capability that makes it dramatically _less_ risky
> to deploy new features.

As I said previously I understand and accept your reasoning here. I think it's risky to believe you can ahead of time code in the ability to understand and correctly revert any possible format change you'll come up with in the future especially since the only reason we're talking about it is because it's already failed at least once. It's also a system that I believe can't be meaningfully tested without a time machine.

But it's your project and I accept your judgement and I have no need to talk about that feature any further (unless you yourself find it helpful to continue the discussion).

Thanks,
Carl
