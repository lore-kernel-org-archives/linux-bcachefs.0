Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66C1F30DE
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000498; cv=none; b=tD/LfLWtEshjydWS3tPcGiukINapW6MT2C0hx+qBn00ZK53o7emUt7WiKCCe8ei4ooefyekfRjKQLWdrrEPwsmJHoGJ8/wFIJT9rDvMcpQN9AW97MohF5j53yMDHQMxytCNlMWDRohopWo3GAwucJKXHccMZa2nCDled4HXh9DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000498; c=relaxed/simple;
	bh=P/YGDyAuI5cdqgreFYOTvG0r4vimRMchc6eat/dWEEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twnu8E3p9HvZXquNY0RCMOHsx8hU1APiMSe/RJu84hQ+Lb5KFxL5sXeadkvgfhMc1l8nCNINlMg4QvPN1az0WCDtgJwRdmIkvCnm3fl+fgJIBSmHXo2D0hFnl18EGIqk5ehjIy1RimOlzvXCusToYMoyu4fE4UxxRwxjclEV+Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AsUx8/vw; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AsUx8/vw"
Date: Wed, 26 Mar 2025 10:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743000484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeUr8pi1jeRPBjVWF8zaOS4IrJNw7MAtgeOuC7rRdTo=;
	b=AsUx8/vwPjbbb4SPcOLAD1Oyq5bVqDikcrp620Zrw4gKD3QGFetMyFo6CRasIMl3bXHQz6
	TrN5ndV4i5L7PFkQ3iDhcySCDh+O5JQNe7wrH8hdIyO3oSlNRL4aUaYEM7iBxyQDHk78/3
	eLaBuqebdZPxWlf1gTkU9Ze1r5ohBNc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
Message-ID: <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
 <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
 <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
 <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 02:40:22PM +0000, Roxana Nicolescu wrote:
> On Wednesday, March 26th, 2025 at 1:19 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Wed, Mar 26, 2025 at 06:02:31PM +0800, Alan Huang wrote:
> > 
> > > On Mar 26, 2025, at 17:44, Roxana Nicolescu nicolescu.roxana@protonmail.com wrote:
> > > 
> > > > strncpy() is deprecated for NUL-terminated destination buffers. Use
> > > > strscpy() instead.
> > > > 
> > > > Link: https://github.com/KSPP/linux/issues/90
> > > > Signed-off-by: Roxana Nicolescu nicolescu.roxana@protonmail.com
> > > > ---
> > > > fs/bcachefs/btree_trans_commit.c | 2 +-
> > > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
> > > > index c4f524b2ca9a..7ab25b425d11 100644
> > > > --- a/fs/bcachefs/btree_trans_commit.c
> > > > +++ b/fs/bcachefs/btree_trans_commit.c
> > > > @@ -364,7 +364,7 @@ static noinline void journal_transaction_name(struct btree_trans *trans)
> > > > struct jset_entry_log *l =
> > > > container_of(entry, struct jset_entry_log, entry);
> > > > 
> > > > - strncpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> > > > + strscpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> > > 
> > > The last time I asked Kent about this line, he didn’t want this.
> > 
> > 
> > Yes, the destination buffer isn't required to be nul terminated.
> > 
> > But it seems we should add a comment explaining that :)
> 
> I should have checked the mailing list before, but I will keep this in mind for my next contributions.
> I wonder if we should use memcpy in this case. This is also recommended by the security team here https://github.com/KSPP/linux/issues/90
> This will also prevent other people from trying to send a similar patch in the future.

Or better, a new helper: when we're copying to a fixed size buffer we
really want to zero out the rest of the buffer - we don't just want a
single terminating nul.

This has come up in other places in bcachefs, see __bch2_fs_log_msg() in
btree_update.c, and I would imagine the code for updating superblock
labels as well.
