Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F91291151
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744728045; cv=none; b=OFJMqUJwbjA6HCfRF78lstDyvducX9ItSTLUJIOEYzNDqaMowkMvB9QgcF7vqSGq7wg4y5jc9fn/0a+dYFeYZRF25SVW2U4D2bEd+8NG8lCQMw3x4HoT3kvx/wgCy9I+1oDRj4A3MHPcc2lAtwSBsrVPQSI9F31ijBObjFclIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744728045; c=relaxed/simple;
	bh=Kdr6QR2ZdQsLakPpH8baSUcPs2AoTFr/ixgs95aFTQY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=i1zdD0LSktWovXqhCMxTndkdBBJChZkcU9fPrdTxwRgZnJZhDuHyiJ/g89t/p7XGFgCXF/hX+teFCMa2llZm76kS8xzaYKaoZxpqWaHp3wOW0ePFPe8rQ+815q1EQVFx/RDDiCedAiJ5rL/mU0fqzjSdZY9tGmy3yqUhNNDJxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C2S/FgUN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2S/FgUN"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22401f4d35aso64911735ad.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 07:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744728043; x=1745332843; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7FiWBCeIuYKGE1xkLacAvlFs1mCyPhKXHMZc9oEFzo=;
        b=C2S/FgUNsmIQfUBYQ8lK7bj3XDQpx2A6ycOAuAz8hP43+2QBRADduVjk3yYWhsOWQB
         xe8VkPpVOxeyMmXvCjB784fBjpAqCaFaQSCxyXoz9L8fN5OJPPO9+DML+9V6DuYKxzct
         bIO2xoxA+HMAQVA51+PRPpHf3PsrXSkPNleW+qxTxEU88HhVaEvIZzxfBcegFM/m0mJr
         d7PJyPHJLQOfCDunr4zJW9mrj8phruqSP5LdOoRZp/7ggZUkkwPMwYyO62A1FqjmiClB
         kRQQyUlfgYugFF3zW+H3J+WNqpA48nXQJR7a96znTidHO5bAH661xckfvLE/s+u+AuTM
         4W6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744728043; x=1745332843;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7FiWBCeIuYKGE1xkLacAvlFs1mCyPhKXHMZc9oEFzo=;
        b=KLTEwaCzrY7LqXn1jNmtYIXuvpwKEudKrXveIP8qZ8N1+2xIcWqHxTvcYlTygD86C/
         BI0bQ1vjbHnLVfdfbvfHUmBn0dbs4D8tngo/HxytBBiN6zCSY5Mt/0517632TMgm4BG9
         XxBlL7ewjcIYAvq7IbZXLhj5gpVZZE804SiD+TQxUEVq+WcGGQis2QpI14zJA9B1neKK
         dCi5kKZ2+3e0GOL9BpIaH7OGD98Q/L+jhoO9HzU333Qgxgy91xjE887phw/tvkG97XSn
         nLlioqIUZSQ6fHAb0UXMudO1W1YO10PoTfn6DEDPg+VEB/cSTDS8tuayFj7crm9IgwuZ
         0e5w==
X-Gm-Message-State: AOJu0Yzis/pJ4+IMCY7wnawkmAQZBKSVoZ7Dlq6mpc0Yq9OGOKwj9Sf3
	T0nO13Sv//0wjWm956WYBA7izead86850pD7kLY6vOBj9jyWg4NS
X-Gm-Gg: ASbGncvVIOHyq7o71LZr3Dew5oJoxVrDKdXB+uFmA+OS3ob8/X2/fbbe+bedEQtXWoG
	op4m321P8CphfgGoTkHaFOsKTmXKXmU7tcg2dpvAsmmqRyYWy1Ho+KsT/6CJhv9j1B/OKbVrTvZ
	VSUR6TL86KAgZtQjhXvpMtqfSHDm69Hw+bUuaf6+FZUQMoqsFtCfFM1JfG7Uy1K4yphQG3tHlff
	pMaEAQq67GyH+E/a+uf9X7WOErjj+aCdijt0itMae938Nj3XXv3pMj6595cjrRJiJu14yauAl8z
	enYH5pqJ5y6th+uVS8cwmpfE
X-Google-Smtp-Source: AGHT+IEYRRutFBbqAv//HbvCOngYcodB4/9CBvqZzrIAL9xWwF0nItJJZ703S0G91ps4Bt45wzFdEw==
X-Received: by 2002:a17:903:3ba7:b0:220:ff3f:6cc0 with SMTP id d9443c01a7336-22bea4f26bbmr274536125ad.38.1744728042546;
        Tue, 15 Apr 2025 07:40:42 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd22f1071sm8504691b3a.120.2025.04.15.07.40.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Apr 2025 07:40:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH 2/4] bcachefs: mark_btree_node_locked_noreset ->
 mark_btree_node_locked_reset
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <lvfufohffjiyabs6avgajstqnfi2va4u4hy3ct73yhcowq4nzo@okzc4pohf4eh>
Date: Tue, 15 Apr 2025 22:40:27 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <173AA1E0-1F73-4F84-91EF-E04BC75F82D2@gmail.com>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
 <20250415053307.81354-3-mmpgouride@gmail.com>
 <lvfufohffjiyabs6avgajstqnfi2va4u4hy3ct73yhcowq4nzo@okzc4pohf4eh>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Apr 15, 2025, at 22:34, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Tue, Apr 15, 2025 at 01:33:05PM +0800, Alan Huang wrote:
>> The semantic is reset now, rename the function to reflect that.
>>=20
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>=20
> erm, are you sure?
>=20
> mark_btree_node_locked() is the outer, more 'standard' interface, we
> generally do the more specialized naming for the inner, more
> specialized, 'are you sure this is the one you want' helper

I checked the git log, the original _noreset helper was no reset =
semantic, that is, add a new state.
And then the logic has been changed, but the name doesn't

>=20
>> ---
>> fs/bcachefs/btree_key_cache.c       |  6 +++---
>> fs/bcachefs/btree_locking.c         |  6 +++---
>> fs/bcachefs/btree_locking.h         | 10 +++++-----
>> fs/bcachefs/btree_update_interior.c |  4 ++--
>> 4 files changed, 13 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/fs/bcachefs/btree_key_cache.c =
b/fs/bcachefs/btree_key_cache.c
>> index 2b186584a291..c7ad01c1355c 100644
>> --- a/fs/bcachefs/btree_key_cache.c
>> +++ b/fs/bcachefs/btree_key_cache.c
>> @@ -240,7 +240,7 @@ static int btree_key_cache_create(struct =
btree_trans *trans,
>> ck->flags =3D 1U << BKEY_CACHED_ACCESSED;
>>=20
>> if (unlikely(key_u64s > ck->u64s)) {
>> - mark_btree_node_locked_noreset(ck_path, 0, BTREE_NODE_UNLOCKED);
>> + mark_btree_node_locked_reset(ck_path, 0, BTREE_NODE_UNLOCKED);
>>=20
>> struct bkey_i *new_k =3D allocate_dropping_locks(trans, ret,
>> kmalloc(key_u64s * sizeof(u64), _gfp));
>> @@ -282,7 +282,7 @@ static int btree_key_cache_create(struct =
btree_trans *trans,
>> return 0;
>> err:
>> bkey_cached_free(bc, ck);
>> - mark_btree_node_locked_noreset(ck_path, 0, BTREE_NODE_UNLOCKED);
>> + mark_btree_node_locked_reset(ck_path, 0, BTREE_NODE_UNLOCKED);
>>=20
>> return ret;
>> }
>> @@ -500,7 +500,7 @@ static int btree_key_cache_flush_pos(struct =
btree_trans *trans,
>> atomic_long_dec(&c->btree_key_cache.nr_dirty);
>> }
>>=20
>> - mark_btree_node_locked_noreset(path, 0, BTREE_NODE_UNLOCKED);
>> + mark_btree_node_locked_reset(path, 0, BTREE_NODE_UNLOCKED);
>> if (bkey_cached_evict(&c->btree_key_cache, ck)) {
>> bkey_cached_free(&c->btree_key_cache, ck);
>> } else {
>> diff --git a/fs/bcachefs/btree_locking.c =
b/fs/bcachefs/btree_locking.c
>> index f4f563944340..71dbac0bcd58 100644
>> --- a/fs/bcachefs/btree_locking.c
>> +++ b/fs/bcachefs/btree_locking.c
>> @@ -435,7 +435,7 @@ int __bch2_btree_node_lock_write(struct =
btree_trans *trans, struct btree_path *p
>> six_lock_readers_add(&b->lock, readers);
>>=20
>> if (ret)
>> - mark_btree_node_locked_noreset(path, b->level, =
BTREE_NODE_INTENT_LOCKED);
>> + mark_btree_node_locked_reset(path, b->level, =
BTREE_NODE_INTENT_LOCKED);
>>=20
>> return ret;
>> }
>> @@ -564,7 +564,7 @@ bool bch2_btree_node_upgrade(struct btree_trans =
*trans,
>> trace_and_count(trans->c, btree_path_upgrade_fail, trans, _RET_IP_, =
path, level);
>> return false;
>> success:
>> - mark_btree_node_locked_noreset(path, level, =
BTREE_NODE_INTENT_LOCKED);
>> + mark_btree_node_locked_reset(path, level, =
BTREE_NODE_INTENT_LOCKED);
>> return true;
>> }
>>=20
>> @@ -693,7 +693,7 @@ void __bch2_btree_path_downgrade(struct =
btree_trans *trans,
>> } else {
>> if (btree_node_intent_locked(path, l)) {
>> six_lock_downgrade(&path->l[l].b->c.lock);
>> - mark_btree_node_locked_noreset(path, l, BTREE_NODE_READ_LOCKED);
>> + mark_btree_node_locked_reset(path, l, BTREE_NODE_READ_LOCKED);
>> }
>> break;
>> }
>> diff --git a/fs/bcachefs/btree_locking.h =
b/fs/bcachefs/btree_locking.h
>> index 66b27c0853a5..8978f7969bef 100644
>> --- a/fs/bcachefs/btree_locking.h
>> +++ b/fs/bcachefs/btree_locking.h
>> @@ -63,7 +63,7 @@ static inline bool btree_node_locked(struct =
btree_path *path, unsigned level)
>> return btree_node_locked_type(path, level) !=3D BTREE_NODE_UNLOCKED;
>> }
>>=20
>> -static inline void mark_btree_node_locked_noreset(struct btree_path =
*path,
>> +static inline void mark_btree_node_locked_reset(struct btree_path =
*path,
>>  unsigned level,
>>  enum btree_node_locked_type type)
>> {
>> @@ -80,7 +80,7 @@ static inline void mark_btree_node_locked(struct =
btree_trans *trans,
>>  unsigned level,
>>  enum btree_node_locked_type type)
>> {
>> - mark_btree_node_locked_noreset(path, level, (enum =
btree_node_locked_type) type);
>> + mark_btree_node_locked_reset(path, level, (enum =
btree_node_locked_type) type);
>> #ifdef CONFIG_BCACHEFS_LOCK_TIME_STATS
>> path->l[level].lock_taken_time =3D local_clock();
>> #endif
>> @@ -134,7 +134,7 @@ static inline void btree_node_unlock(struct =
btree_trans *trans,
>> }
>> six_unlock_type(&path->l[level].b->c.lock, lock_type);
>> btree_trans_lock_hold_time_update(trans, path, level);
>> - mark_btree_node_locked_noreset(path, level, BTREE_NODE_UNLOCKED);
>> + mark_btree_node_locked_reset(path, level, BTREE_NODE_UNLOCKED);
>> }
>> }
>>=20
>> @@ -183,7 +183,7 @@ bch2_btree_node_unlock_write_inlined(struct =
btree_trans *trans, struct btree_pat
>> EBUG_ON(path->l[b->c.level].lock_seq !=3D six_lock_seq(&b->c.lock));
>> EBUG_ON(btree_node_locked_type(path, b->c.level) !=3D =
SIX_LOCK_write);
>>=20
>> - mark_btree_node_locked_noreset(path, b->c.level, =
BTREE_NODE_INTENT_LOCKED);
>> + mark_btree_node_locked_reset(path, b->c.level, =
BTREE_NODE_INTENT_LOCKED);
>> __bch2_btree_node_unlock_write(trans, b);
>> }
>>=20
>> @@ -315,7 +315,7 @@ static inline int __btree_node_lock_write(struct =
btree_trans *trans,
>> * write lock: thus, we need to tell the cycle detector we have a =
write
>> * lock _before_ taking the lock:
>> */
>> - mark_btree_node_locked_noreset(path, b->level, =
BTREE_NODE_WRITE_LOCKED);
>> + mark_btree_node_locked_reset(path, b->level, =
BTREE_NODE_WRITE_LOCKED);
>>=20
>> return likely(six_trylock_write(&b->lock))
>> ? 0
>> diff --git a/fs/bcachefs/btree_update_interior.c =
b/fs/bcachefs/btree_update_interior.c
>> index 55fbeeb8eaaa..29e03408a019 100644
>> --- a/fs/bcachefs/btree_update_interior.c
>> +++ b/fs/bcachefs/btree_update_interior.c
>> @@ -245,7 +245,7 @@ static void bch2_btree_node_free_inmem(struct =
btree_trans *trans,
>> mutex_unlock(&c->btree_cache.lock);
>>=20
>> six_unlock_write(&b->c.lock);
>> - mark_btree_node_locked_noreset(path, b->c.level, =
BTREE_NODE_INTENT_LOCKED);
>> + mark_btree_node_locked_reset(path, b->c.level, =
BTREE_NODE_INTENT_LOCKED);
>>=20
>> bch2_trans_node_drop(trans, b);
>> }
>> @@ -788,7 +788,7 @@ static void btree_update_nodes_written(struct =
btree_update *as)
>>=20
>> mutex_unlock(&c->btree_interior_update_lock);
>>=20
>> - mark_btree_node_locked_noreset(path, b->c.level, =
BTREE_NODE_INTENT_LOCKED);
>> + mark_btree_node_locked_reset(path, b->c.level, =
BTREE_NODE_INTENT_LOCKED);
>> six_unlock_write(&b->c.lock);
>>=20
>> btree_node_write_if_need(trans, b, SIX_LOCK_intent);
>> --=20
>> 2.48.1
>>=20

