Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA906207DFD
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742307970; cv=none; b=nMGragVwpkWCqVKXWiyZl2r7Cyf9Ch9AVmbaNBS4s4+CYWEYZv31V/Y/Sw+rjPdPgbuVNN1S9j86QVuJDrWhDoOeeWmkNy0muEqzQFA6emg/ji3XA0rHFQKvs3GuyFSkAK9YzTcpGGjpYSEsnM/sd7BFYotgSZb2cFUEJ5oT7+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742307970; c=relaxed/simple;
	bh=PvuCiE82m1VTKzFqDJ8b+aKefao3GNmB6T0kKBWDYrA=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=gcR86MAdL3fRV4EWpDt++wI1jWbt3+XrCSWj+gyNeKw3QsV9m6k6fR2fhfo6qy4mCUPlVmPBK7qdPX6IGgDz+z1thTwLQb7onkVM57QZyJEUSS8W11QAS3NvT2Ni02WYMmLsCywe/Kau0rKfrA9Z8733t3ZyS89rVYJHfxUGF3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id C6A731E1D9;
	Tue, 18 Mar 2025 10:26:03 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 479C7A0E80; Tue, 18 Mar 2025 10:26:03 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26585.33403.270413.729999@quad.stoffel.home>
Date: Tue, 18 Mar 2025 10:26:03 -0400
From: "John Stoffel" <john@stoffel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: John Stoffel <john@stoffel.org>,
    Alan Huang <mmpgouride@gmail.com>,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH] bcachefs: Increase blacklist range
In-Reply-To: <gchq6w4tyrx4wxjepyfoerprnsp3jlzm2acel4hfaf4z3jp4iw@53mpn6u5edc7>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
	<26584.36082.936426.143774@quad.stoffel.home>
	<gchq6w4tyrx4wxjepyfoerprnsp3jlzm2acel4hfaf4z3jp4iw@53mpn6u5edc7>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Mon, Mar 17, 2025 at 04:58:26PM -0400, John Stoffel wrote:
>> >>>>> "Alan" == Alan Huang <mmpgouride@gmail.com> writes:
>> 
>> > Now there are 16 journal buffers, 8 is too small to be enough.
>> > Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> > ---
>> >  fs/bcachefs/recovery.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
>> > index 71c786cdb192..a6e26733854d 100644
>> > --- a/fs/bcachefs/recovery.c
>> > +++ b/fs/bcachefs/recovery.c
>> > @@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
>> >  	 * journal sequence numbers:
>> >  	 */
>> >  	if (!c->sb.clean)
>> > -		journal_seq += 8;
>> > +		journal_seq += JOURNAL_BUF_NR * 4;
>> 
>> Instead of magic numbers, could you put in a define with an
>> explanation of how you arrived at this number?  Just to document the
>> assumptions better?
>> 
>> John

> The * 4 is a fudge factor.

Ok.

> But actually, I was giving this more thought and I don't think we have
> the correct number.

We have a WAG here.  :-)

> The real bound is "number of unflushed journal entries that might have
> been allocated, and have other items (btree nodes) referring to that
> sequence number, but which don't hit because beacuse they weren't
> flushed".

> And we don't have an actual bound on that.

So what happens if journal_seq overflows?  I don't know the code and
haven't looked.   
