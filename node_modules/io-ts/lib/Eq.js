"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * @since 2.2.2
 */
var A = require("fp-ts/lib/Array");
var E = require("fp-ts/lib/Eq");
var R = require("fp-ts/lib/Record");
var S = require("./Schemable");
// -------------------------------------------------------------------------------------
// primitives
// -------------------------------------------------------------------------------------
/**
 * @since 2.2.2
 */
exports.string = E.eqString;
/**
 * @since 2.2.2
 */
exports.number = E.eqNumber;
/**
 * @since 2.2.2
 */
exports.boolean = E.eqBoolean;
/**
 * @since 2.2.2
 */
exports.UnknownArray = E.fromEquals(function (x, y) { return x.length === y.length; });
/**
 * @since 2.2.2
 */
exports.UnknownRecord = E.fromEquals(function (x, y) {
    for (var k in x) {
        if (!(k in y)) {
            return false;
        }
    }
    for (var k in y) {
        if (!(k in x)) {
            return false;
        }
    }
    return true;
});
// -------------------------------------------------------------------------------------
// combinators
// -------------------------------------------------------------------------------------
/**
 * @since 2.2.2
 */
function nullable(or) {
    return {
        equals: function (x, y) { return (x === null || y === null ? x === y : or.equals(x, y)); }
    };
}
exports.nullable = nullable;
/**
 * @since 2.2.2
 */
exports.type = E.getStructEq;
/**
 * @since 2.2.2
 */
function partial(properties) {
    return {
        equals: function (x, y) {
            for (var k in properties) {
                var xk = x[k];
                var yk = y[k];
                if (!(xk === undefined || yk === undefined ? xk === yk : properties[k].equals(xk, yk))) {
                    return false;
                }
            }
            return true;
        }
    };
}
exports.partial = partial;
/**
 * @since 2.2.2
 */
exports.record = R.getEq;
/**
 * @since 2.2.2
 */
exports.array = A.getEq;
/**
 * @since 2.2.2
 */
exports.tuple = E.getTupleEq;
/**
 * @since 2.2.2
 */
function intersection(left, right) {
    return {
        equals: function (x, y) { return left.equals(x, y) && right.equals(x, y); }
    };
}
exports.intersection = intersection;
/**
 * @since 2.2.2
 */
function sum(tag) {
    return function (members) {
        return {
            equals: function (x, y) {
                var vx = x[tag];
                var vy = y[tag];
                if (vx !== vy) {
                    return false;
                }
                return members[vx].equals(x, y);
            }
        };
    };
}
exports.sum = sum;
/**
 * @since 2.2.2
 */
function lazy(f) {
    var get = S.memoize(f);
    return {
        equals: function (x, y) { return get().equals(x, y); }
    };
}
exports.lazy = lazy;
/**
 * @since 2.2.2
 */
exports.eq = __assign(__assign({}, E.eq), { literal: function () { return E.eqStrict; }, string: exports.string,
    number: exports.number,
    boolean: exports.boolean,
    UnknownArray: exports.UnknownArray,
    UnknownRecord: exports.UnknownRecord,
    nullable: nullable,
    type: exports.type,
    partial: partial,
    record: exports.record,
    array: exports.array,
    tuple: exports.tuple,
    intersection: intersection,
    sum: sum, lazy: function (_, f) { return lazy(f); } });
